const std = @import("std");
const raw = @import("shim.zig");
const n = @import("napi_types.zig");
const znapi = @import("znapi.zig");
const builtin = @import("builtin");

const err = znapi.statusToError;
const c_alloc = std.heap.c_allocator;

pub const Ctx = @This();

env: n.napi_env,
null: n.napi_value,
undefined: n.napi_value,

pub fn init(env: n.napi_env) !*Ctx {
    const c = try c_alloc.create(Ctx);

    c.* = .{
        .env = env,
        .null = undefined,
        .undefined = undefined,
    };

    raw.initialize();
    try err(raw.napi_get_null(env, &c.null));
    try err(raw.napi_get_undefined(env, &c.undefined));

    try err(raw.napi_set_instance_data(@ptrCast(env), c, finalize, c));

    return c;
}

pub fn deinit(c: *Ctx) void {
    c_alloc.destroy(c);
}

fn finalize(_: n.napi_env, data: ?*anyopaque, _: ?*anyopaque) callconv(.C) void {
    const c: *Ctx = @ptrCast(@alignCast(data));
    c.deinit();
}

pub const TranslationError = error{ExceptionThrown} || znapi.napi_error;
pub fn throw(ctx: Ctx, message: [:0]const u8) TranslationError {
    try err(raw.napi_throw_error(ctx.env, null, message));
    return TranslationError.ExceptionThrown;
}

pub fn toNapiValue(ctx: *Ctx, val: anytype) TranslationError!n.napi_value {
    const T = @TypeOf(val);

    if (T == n.napi_value) return val;

    return switch (@typeInfo(T)) {
        .Undefined => ctx.undefined,
        .Null => ctx.null,
        .Bool => try ctx.createBoolean(val),
        .Fn => try ctx.createFunction(val, null, null),
        .Int => try ctx.createInt(val),
        .Float => try ctx.createFloat(val),
        .Enum => try ctx.createUint32(@intFromEnum(val)),
        .Optional => if (val) |v| try ctx.toNapiValue(v) else ctx.null,
        .Array, .Vector => try ctx.createArrayFrom(val),
        .Struct => |i| if (i.is_tuple) try ctx.createTuple(val) else try ctx.createObjectFrom(val),
        .Union => ctx.createUnion(val),
        .Pointer => |i| switch (i.size) {
            .Slice => try ctx.createArrayFrom(val),
            .One => {
                const ci = @typeInfo(i.child);
                if (ci == .Array and ci.Array.child == u8 and ci.Array.sentinel != null and @as(*const u8, @ptrCast(ci.Array.sentinel)).* == 0) {
                    return try ctx.createString(val);
                }
                @compileError("Cannot convert a One item pointer to a napi_value");
            },
            .C => @compileError("Cannot convert C pointer to a napi_value, please cast to a slice if possible"),
            .Many => @compileError("Cannot convert Many item pointer to a napi_value, please cast to a slice"),
        },
        .ComptimeInt => @compileError("Cannot convert comptime integer to a napi_value, please cast to an appropriately sized int"),
        .ComptimeFloat => @compileError("Cannot convert comptime float to a napi_value, please cast to an appropriately sized float"),

        else => @compileError("Unsupported type: " ++ @typeName(T)),
    };
}

pub const ctxCallback = fn (ctx: *Ctx, cbi: n.napi_callback_info) anyerror!n.napi_value;
pub fn createFunction(ctx: *Ctx, comptime f: ctxCallback, comptime name: ?[]const u8, data: ?*anyopaque) TranslationError!n.napi_value {
    const wrapper = struct {
        fn cb(env: n.napi_env, cbi: n.napi_callback_info) callconv(.C) n.napi_value {
            var c: *Ctx = undefined;
            err(raw.napi_get_instance_data(@ptrCast(env), @ptrCast(&c))) catch @panic("napi_get_instance_data failed");
            const res = f(c, cbi);

            return switch (@typeInfo(@typeInfo(@TypeOf(f)).Fn.return_type.?)) {
                .ErrorUnion => {
                    return res catch |ec| c.throw(@errorName(ec)) catch null;
                },
                else => res,
            };
        }
    };
    var result: n.napi_value = undefined;

    if (name) |na| {
        try err(raw.napi_create_function(ctx.env, na.ptr, na.len, wrapper.cb, data, &result));
    } else {
        try err(raw.napi_create_function(ctx.env, null, 0, wrapper.cb, data, &result));
    }

    return result;
}

pub fn createInt(ctx: *Ctx, val: anytype) !n.napi_value {
    const ti = switch (@typeInfo(@TypeOf(val))) {
        .Int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(@TypeOf(val))),
    };

    if (ti.bits > 64) return ctx.createBigintLarge(@TypeOf(val), val);

    if (ti.signedness == .unsigned) {
        if (ti.bits <= 32) return try ctx.createUint32(@intCast(val));
        if (ti.bits <= 64) return try ctx.createBigintUint64(@intCast(val));

        var bytes: [@divExact(ti.bits, 8)]u8 = undefined;
        std.mem.writeInt(@TypeOf(val), &bytes, val, .little);
        return try ctx.createBigintBytes(false, bytes[0..]);
    } else {
        if (ti.bits <= 32) return try ctx.createInt32(@intCast(val));
        if (ti.bits <= 64) return try ctx.createBigintInt64(@intCast(val));

        var bytes: [@divExact(ti.bits, 8)]u8 = undefined;
        std.mem.writeInt(@TypeOf(val), &bytes, if (val > 0) val else -val, .little); // we dont want twos complement.
        return try ctx.createBigintBytes(val < 0, bytes[0..]);
    }
}

pub fn createBigintLarge(ctx: *Ctx, comptime T: type, val: T) !n.napi_value {
    const ti = switch (@typeInfo(T)) {
        .Int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(T)),
    };
    if (ti.bits <= 64) @compileError("Expected a larger integer, got: " ++ @typeName(T));

    const wc: usize = ti.bits / 64 + 1;
    var words: [wc]u64 align(@alignOf(T)) = [_]u64{0} ** wc;

    inline for (0..wc) |i| {
        words[i] = @truncate(val >> (i * 64));
    }

    if (comptime builtin.target.cpu.arch.endian() != .little) @compileError("TODO: implement big endian bigints");

    var res: n.napi_value = undefined;
    try err(raw.napi_create_bigint_words(ctx.env, @intFromBool(val < 0), wc, @ptrCast(&words), &res));

    return res;
}

pub fn createUint32(ctx: *Ctx, val: u32) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_uint32(ctx.env, val, &res));
    return res;
}

pub fn createInt32(ctx: *Ctx, val: i32) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_int32(ctx.env, val, &res));
    return res;
}

pub fn createBigintUint64(ctx: *Ctx, val: u64) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_bigint_uint64(ctx.env, val, &res));
    return res;
}

pub fn createBigintInt64(ctx: *Ctx, val: i64) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_bigint_int64(ctx.env, val, &res));
    return res;
}

pub fn createBigintBytes(ctx: *Ctx, sign: bool, bytes: []const u8) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_bigint_words(ctx.env, @intFromBool(sign), bytes.len / 8, @ptrCast(@alignCast(bytes.ptr)), &res));
    return res;
}

pub fn createFloat(ctx: *Ctx, val: anytype) !n.napi_value {
    const ti = @typeInfo(@TypeOf(val));
    if (ti != .Float) @compileError("Expected a float, got: " ++ @typeName(@TypeOf(val)));
    if (ti.Float.bits <= 64) return try ctx.createDouble(@floatCast(val));
    @compileError("Cannot convert float with more than 64 bits to double, please cast yourself.");
}

pub fn createDouble(ctx: *Ctx, val: f64) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_double(ctx.env, val, &res));
    return res;
}

pub fn createBoolean(ctx: *Ctx, val: bool) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_boolean(ctx.env, val, &res));
    return res;
}

pub fn createArray(ctx: *Ctx, len: ?usize) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(if (len) |l| raw.napi_create_array_with_length(ctx.env, l, &res) else raw.napi_create_array(ctx.env, &res));
    return res;
}

pub fn createArrayFrom(ctx: *Ctx, arr: anytype) !n.napi_value {
    const len = switch (@typeInfo(@TypeOf(arr))) {
        .Array => |i| i.len,
        .Vector => |i| i.len,
        .Pointer => |i| if (i.size == .Slice) arr.len else @compileError("Expected Slice size to be of type .Pointer"),
        else => @compileError("Expected Array or Vector, got: " ++ @typeName(@TypeOf(arr))),
    };

    const res = try ctx.createArray(len);
    for (0..len) |i| {
        try ctx.setElement(res, i, try ctx.toNapiValue(arr[i]));
    }
    return res;
}

pub fn createObject(ctx: *Ctx) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_object(ctx.env, &res));
    return res;
}

pub fn createObjectFrom(ctx: *Ctx, obj: anytype) !n.napi_value {
    const T = @TypeOf(obj);
    const res = try ctx.createObject();

    inline for (comptime std.meta.fieldNames(T)) |name| {
        try ctx.setNamedProperty(res, name, try ctx.toNapiValue(@field(obj, name)));
    }

    return res;
}

pub fn createTuple(ctx: *Ctx, tuple: anytype) !n.napi_value {
    const fieldNames = comptime std.meta.fieldNames(tuple);
    const res = try ctx.createArray(fieldNames.len);
    inline for (fieldNames, 0..) |name, i| {
        try ctx.setElement(res, i, try ctx.toNapiValue(@field(tuple, name)));
    }
    return res;
}

pub fn createPropertyKey(ctx: *Ctx, utf8name: []const u8) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.node_api_create_property_key_utf8(ctx.env, utf8name.ptr, utf8name.len, &res));
    return res;
}

pub fn createUnion(ctx: *Ctx, u: anytype) !n.napi_value {
    if (@typeInfo(@TypeOf(u)) != .Union) @compileError("Expected a union type, got: " ++ @typeName(@TypeOf(u)));

    switch (u) {
        inline else => |un| {
            const res = try ctx.createObject();
            try ctx.setNamedProperty(res, @tagName(u), try ctx.toNapiValue(un));
            return res;
        },
    }
}

pub fn createString(ctx: *Ctx, str: []const u8) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_string_utf8(ctx.env, str.ptr, str.len, &res));
    return res;
}

pub fn createArrayBuffer(ctx: *Ctx, data: []const u8) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_create_buffer_copy(ctx.env, data.len, data.ptr, null, &res));
    return res;
}

pub const parseError = error{ OutOfMemory, UndefinedExpected, NullExpected, BoolExpected, ArrayExpected, ObjectExpected, InvalidUnion } || znapi.napi_error;
/// parse a napi_value to a zig type
/// allocator is optional, comptime check for necessity
pub fn parseNapiValue(ctx: *Ctx, schema: type, val: n.napi_value, allocator: ?std.mem.Allocator) !schema {
    if (schema == n.napi_value) return val;

    return switch (@typeInfo(schema)) {
        .Undefined => if (try ctx.napiTypeOf(val) == .undefined) undefined else parseError.UndefinedExpected,
        .Null => if (try ctx.napiTypeOf(val) == .null) null else parseError.NullExpected,
        .Bool => try ctx.getBool(val),
        .Optional => |i| if (try ctx.napiTypeOf(val) == .undefined) null else try ctx.parseNapiValue(i.child, val, allocator),
        .Int => try ctx.getInt(schema, val),
        .Float => try ctx.getFloat(schema, val),
        .Struct => |info| if (info.is_tuple) try ctx.getTuple(schema, val, allocator) else try ctx.getStruct(schema, val, allocator),
        .Array, .Vector => try ctx.getArray(schema, val, allocator),
        .Pointer => |info| {
            if (info.size != .Slice) @compileError("Pointer size must be .Slice");
            if (info.child == u8 and info.sentinel != null and @as(*const u8, @ptrCast(info.sentinel)).* == 0) {
                return try ctx.getStringUtf8(val, allocator);
            }
            return try ctx.getSlice(schema, val, allocator);
        },
        .ErrorUnion => |info| {
            // we cannot return the error, because not bubbling it up is hard.
            // therefore we require optional and return null in fail case.
            // this is different from a normal optional and nulls misinputs
            if (@typeInfo(info.payload) != .Optional) @compileError("Error union payload must be optional");
            return ctx.parseNapiValue(info.payload, val, allocator) catch null;
        },
        .Union => ctx.getUnion(schema, val, allocator),

        else => @compileError("Unsupported type: " ++ @typeName(schema)),
    };
}

pub fn parseArgs(ctx: *Ctx, comptime schema: anytype, cbi: n.napi_callback_info, allocator: ?std.mem.Allocator) !schema {
    const ti = switch (@typeInfo(schema)) {
        .Struct => |i| i,
        else => @compileError("Expected a tuple, got: " ++ @typeName(schema)),
    };
    if (!ti.is_tuple) @compileError("Expected a tuple, got: " ++ @typeName(schema));

    const args = try ctx.getCbArgs(cbi, ti.fields.len);

    var ret: schema = undefined;
    inline for (0..ti.fields.len) |i| {
        ret[i] = try ctx.parseNapiValue(ti.fields[i].type, args[i], allocator);
    }

    return ret;
}

pub fn getThisArg(ctx: *Ctx, cbi: n.napi_callback_info) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_cb_info(ctx.env, cbi, null, null, &res, null));
    return res;
}

pub fn getCbData(ctx: *Ctx, cbi: n.napi_callback_info) !?*anyopaque {
    var res: ?*anyopaque = undefined;
    try err(raw.napi_get_cb_info(ctx.env, cbi, null, null, null, &res));
    return res;
}

pub fn getCbArgs(ctx: *Ctx, cbi: n.napi_callback_info, comptime argc: usize) ![argc]n.napi_value {
    var res: [argc]n.napi_value = undefined;
    var argcRes = argc;
    try err(raw.napi_get_cb_info(ctx.env, cbi, &argcRes, &res, null, null));
    return res;
}

pub fn getInt(ctx: *Ctx, comptime T: type, val: n.napi_value) parseError!T {
    const ti = switch (@typeInfo(T)) {
        .Int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(T)),
    };

    if (ti.bits > 64) return ctx.getBigintLarge(T, val);

    if (ti.signedness == .unsigned) {
        if (ti.bits <= 32) return @truncate(try ctx.getUint32(val));
        if (ti.bits <= 64) return @truncate(try ctx.getBigintUint64(val));
    } else {
        if (ti.bits <= 32) return @truncate(try ctx.getInt32(val));
        if (ti.bits <= 64) return @truncate(try ctx.getBigintInt64(val));
    }
}

pub fn getBigintLarge(ctx: *Ctx, comptime T: type, val: n.napi_value) !T {
    const ti = switch (@typeInfo(T)) {
        .Int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(T)),
    };
    if (ti.bits <= 64) @compileError("Expected a larger integer, got: " ++ @typeName(T));

    const wc: usize = ti.bits / 64 + 1;
    var _wc: usize = wc;
    var words: [wc]u64 align(@alignOf(T)) = [_]u64{0} ** wc;
    var sign: c_int = undefined;
    try err(raw.napi_get_value_bigint_words(ctx.env, val, &sign, &_wc, @ptrCast(&words)));

    if (comptime builtin.target.cpu.arch.endian() != .little) @compileError("TODO: implement big endian bigints");

    const ret = @as(*T, @ptrCast(&words)).*;
    return if (ti.signedness == .signed and sign != 0) -ret else ret;
}

pub fn getUint32(ctx: *Ctx, val: n.napi_value) !u32 {
    var res: u32 = undefined;
    try err(raw.napi_get_value_uint32(ctx.env, val, &res));
    return res;
}

pub fn getInt32(ctx: *Ctx, val: n.napi_value) !i32 {
    var res: i32 = undefined;
    try err(raw.napi_get_value_int32(ctx.env, val, &res));
    return res;
}

pub fn getBigintUint64(ctx: *Ctx, val: n.napi_value) !u64 {
    var res: u64 = undefined;
    try err(raw.napi_get_value_bigint_uint64(ctx.env, val, &res));
    return res;
}

pub fn getBigintInt64(ctx: *Ctx, val: n.napi_value) !i64 {
    var res: i64 = undefined;
    try err(raw.napi_get_value_bigint_int64(ctx.env, val, &res));
    return res;
}

pub fn getFloat(ctx: *Ctx, comptime T: type, val: n.napi_value) parseError!T {
    const ti = @typeInfo(T);
    if (ti != .Float) @compileError("Expected a float, got: " ++ @typeName(T));

    return @floatCast(try ctx.getDouble(val));
}

pub fn getDouble(ctx: *Ctx, val: n.napi_value) !f64 {
    var res: f64 = undefined;
    try err(raw.napi_get_value_double(ctx.env, val, &res));
    return res;
}

pub fn getBool(ctx: *Ctx, val: n.napi_value) !bool {
    var res: bool = undefined;
    try err(raw.napi_get_value_bool(ctx.env, val, &res));
    return res;
}

pub fn getArrayLength(ctx: *Ctx, val: n.napi_value) !u32 {
    var res: u32 = undefined;
    try err(raw.napi_get_array_length(ctx.env, val, &res));
    return res;
}

pub fn getElement(ctx: *Ctx, val: n.napi_value, index: usize) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_element(ctx.env, val, @intCast(index), &res));
    return res;
}

pub fn getProperty(ctx: *Ctx, object: n.napi_value, key: []const u8) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_property(ctx.env, object, try ctx.createPropertyKey(key), &res));
    return res;
}

pub fn getProperty2(ctx: *Ctx, object: n.napi_value, key: n.napi_value) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_property(ctx.env, object, key, &res));
    return res;
}

pub fn getStringLatin1(ctx: *Ctx, val: n.napi_value, allocator: std.mem.Allocator) ![:0]const u8 {
    var length: usize = undefined;
    try err(raw.napi_get_value_string_latin1(ctx.env, val, null, 0, &length));
    const res = try allocator.allocSentinel(u8, length, 0);
    try err(raw.napi_get_value_string_latin1(ctx.env, val, res.ptr, length + 1, null));
    return res;
}

pub fn getStringUtf8(ctx: *Ctx, val: n.napi_value, allocator: std.mem.Allocator) ![:0]const u8 {
    var length: usize = undefined;
    try err(raw.napi_get_value_string_utf8(ctx.env, val, null, 0, &length));
    const res = try allocator.allocSentinel(u8, length, 0);
    try err(raw.napi_get_value_string_utf8(ctx.env, val, res.ptr, length + 1, null));
    return res;
}

pub fn getStringUtf16(ctx: *Ctx, val: n.napi_value, allocator: std.mem.Allocator) ![:0]const u16 {
    var length: usize = undefined;
    try err(raw.napi_get_value_string_utf16(ctx.env, val, null, 0, &length));
    const res = try allocator.allocSentinel(u16, length, 0);
    try err(raw.napi_get_value_string_utf16(ctx.env, val, res.ptr, length + 1, null));
    return res;
}

pub fn getTuple(ctx: *Ctx, comptime T: type, val: n.napi_value, allocator: ?std.mem.Allocator) parseError!T {
    if (ctx.napiTypeOf(val) != .array) return parseError.ArrayExpected;
    const res: T = undefined;
    inline for (std.meta.fieldNames(T), 0..) |name, i| {
        @field(res, name) = try ctx.parseNapiValue(@field(T, name), try ctx.getElement(val, i), allocator);
    }
    return res;
}

pub fn getStruct(ctx: *Ctx, comptime T: type, val: n.napi_value, allocator: ?std.mem.Allocator) parseError!T {
    if (@typeInfo(T) != .Struct or @typeInfo(T).Struct.is_tuple) @compileError("Expected a struct, got: " ++ @typeName(T));
    var res: T = undefined;
    inline for (std.meta.fields(T)) |field| {
        @field(res, field.name) = try ctx.parseNapiValue(field.type, try ctx.getProperty(val, field.name), allocator);
    }
    return res;
}

pub fn getArray(ctx: *Ctx, comptime T: type, val: n.napi_value, allocator: ?std.mem.Allocator) parseError!T {
    const ti = switch (@typeInfo(T)) {
        .Array => |i| i,
        .Vector => |i| i,
        else => @compileError("Expected Array or Vector, got: " ++ @typeName(T)),
    };

    if (!try ctx.isArray(val)) return parseError.ArrayExpected;
    var res: T = undefined;
    inline for (0..ti.len) |i| {
        res[i] = try ctx.parseNapiValue(ti.child, try ctx.getElement(val, i), allocator);
    }

    return res;
}

pub fn getSlice(ctx: *Ctx, comptime T: type, val: n.napi_value, allocator: std.mem.Allocator) parseError!T {
    const ti = @typeInfo(T);
    if (ti != .Pointer or ti.Pointer.size != .Slice) @compileError("Expected a slice type, got: " ++ @typeName(T));
    const len = try ctx.getArrayLength(val);

    const res = if (ti.Pointer.sentinel != null) try allocator.allocSentinel(ti.Pointer.child, len, @as(*const ti.Pointer.child, @ptrCast(ti.Pointer.sentinel)).*) else try allocator.alloc(ti.Pointer.child, len);
    for (0..len) |i| {
        res[i] = try ctx.parseNapiValue(ti.Pointer.child, try ctx.getElement(val, i), allocator);
    }
    return res;
}

pub fn getAllPropertyNames(ctx: *Ctx, val: n.napi_value, key_mode: n.napi_key_collection_mode, key_filter: n.napi_key_filter, key_conversion: n.napi_key_conversion) !n.napi_value {
    var res: n.napi_value = undefined;
    try err(raw.napi_get_all_property_names(ctx.env, val, key_mode, key_filter, key_conversion, &res));
    return res;
}

pub fn getUnion(ctx: *Ctx, comptime T: type, val: n.napi_value, allocator: std.mem.Allocator) parseError!T {
    const ti = switch (@typeInfo(T)) {
        .Union => |i| i,
        else => @compileError("Expected a union type, got: " ++ @typeName(T)),
    };

    const propNames = try ctx.getAllPropertyNames(val, n.napi_key_collection_mode.own_only, n.napi_key_filter.only_enumerable, n.napi_key_conversion.numbers_to_strings);
    const len = try ctx.getArrayLength(propNames);
    if (len != 1) return parseError.InvalidUnion;
    const activeField = try ctx.getStringUtf8(try ctx.getElement(propNames, 0), allocator);

    inline for (ti.fields) |field| {
        if (std.mem.eql(u8, field.name, activeField)) {
            return @unionInit(T, field.name, try ctx.parseNapiValue(field.type, try ctx.getProperty(val, field.name), allocator));
        }
    }

    return parseError.InvalidUnion;
}

pub fn getBufferInfo(ctx: *Ctx, buf: n.napi_value) ![]const u8 {
    var data: ?*anyopaque = undefined;
    var len: usize = undefined;
    try err(raw.napi_get_buffer_info(ctx.env, buf, &data, &len));

    if (data == null) return &[0]u8{};

    return @as([*]const u8, @ptrCast(data))[0..len];
}

pub fn getBigintBytes(ctx: *Ctx, value: n.napi_value, allocator: std.mem.Allocator) !struct { sign: bool, bytes: []const u8 } {
    var word_count: usize = undefined;
    try err(raw.napi_get_value_bigint_words(ctx.env, value, null, &word_count, null));

    var sign: c_int = undefined;
    const bytes = try allocator.alignedAlloc(u8, @alignOf(u64), word_count * 8);
    try err(raw.napi_get_value_bigint_words(ctx.env, value, &sign, &word_count, @ptrCast(@alignCast(bytes.ptr))));

    return .{ .sign = sign != 0, .bytes = bytes };
}

pub fn setElement(ctx: *Ctx, arr: n.napi_value, index: usize, value: n.napi_value) !void {
    try err(raw.napi_set_element(ctx.env, arr, @intCast(index), value));
}

pub fn napiTypeOf(ctx: *Ctx, val: n.napi_value) !n.napi_valuetype {
    var res: n.napi_valuetype = undefined;
    try err(raw.napi_typeof(ctx.env, val, &res));
    return res;
}

pub fn isArray(ctx: *Ctx, val: n.napi_value) !bool {
    var res: bool = undefined;
    try err(raw.napi_is_array(ctx.env, val, &res));
    return res;
}

pub fn objectAssign(ctx: *Ctx, target: n.napi_value, source: n.napi_value) !void {
    const keys = try ctx.getAllPropertyNames(source, n.napi_key_collection_mode.own_only, n.napi_key_filter.only_enumerable, n.napi_key_conversion.numbers_to_strings);
    const len = try ctx.getArrayLength(keys);

    for (0..len) |i| {
        const key = try ctx.getElement(keys, i);
        try ctx.setProperty(target, key, try ctx.getProperty2(source, key));
    }
}

pub fn setNamedProperty(ctx: *Ctx, obj: n.napi_value, name: [:0]const u8, value: n.napi_value) !void {
    try err(raw.napi_set_named_property(ctx.env, obj, name.ptr, value));
}

pub fn setProperty(ctx: *Ctx, obj: n.napi_value, key: n.napi_value, value: n.napi_value) !void {
    try err(raw.napi_set_property(ctx.env, obj, key, value));
}
