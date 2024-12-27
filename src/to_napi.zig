const std = @import("std");
const n = @import("napi_types.zig");
const shim = @import("shim.zig");
const Ctx = @import("ctx.zig");
const napi_errors = @import("errors.zig");

fn typeWithoutSignedness(comptime T: type) type {
    const ti = switch (@typeInfo(T)) {
        .int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(T)),
    };

    if (ti.signedness == .unsigned) return T;
    return @Type(.{ .int = .{ .signedness = .unsigned, .bits = ti.bits - 1 } });
}

fn absolute(val: anytype) typeWithoutSignedness(@TypeOf(val)) {
    return @truncate(@abs(val));
}

pub fn createInt(ctx: *const Ctx, val: anytype) !n.napi_value {
    const T = @TypeOf(val);
    const ti = switch (@typeInfo(T)) {
        .int => |i| i,
        else => @compileError("Expected an integer, got: " ++ @typeName(T)),
    };

    if (ti.bits > 64) {
        const abs = absolute(val);
        const ti2 = @typeInfo(@TypeOf(abs)).int;

        const wc = (ti2.bits - 1) / 64 + 1;
        var words: [wc]u64 align(@alignOf(@TypeOf(abs))) = undefined;

        var cur = abs;
        inline for (0..wc - 1) |i| {
            words[i] = @truncate(abs);
            cur >>= 64;
        }
        words[wc - 1] = 0; // TODO: check if removable? trunc cur *should* always be at least 64 bits
        words[wc - 1] = @truncate(cur);

        return ctx.createBigintWords(val < 0, words[0..]);
    }

    if (ti.signedness == .unsigned) {
        if (ti.bits <= 32) return try ctx.createU32(val);
        return try ctx.createBigintU64(val);
    } else {
        if (ti.bits <= 32) return try ctx.createI32(val);
        return try ctx.createBigintI64(val);
    }
}

pub fn createFloat(ctx: *const Ctx, val: anytype) !n.napi_value {
    return switch (@typeInfo(@TypeOf(val))) {
        .float => |f| switch (f.bits) {
            16, 32, 64 => try ctx.createDouble(val),
            else => @compileError("Converting f" ++ f.bits ++ " to a napi_value float would incur a loss of precision, please lower the precision yourself"),
        },
        else => |t| @compileError("Cannot convert type " ++ @typeName(t) ++ " to napi_value float"),
    };
}

pub fn createArrayFrom(ctx: *const Ctx, val: anytype) !n.napi_value {
    const ti = @typeInfo(@TypeOf(val));
    const len = switch (ti) {
        inline .array, .vector => |t| t.len,
        .@"struct" => |s| if (s.is_tuple) val.len else @compileError("Can only create arrays from structs that are tuples"),
        .pointer => |p| if (p.size == .Slice) val.len else @compileError("Can only create arrays from pointers of type slice"),
        else => @compileError("Can only create arrays from slices, arrays, vectors and tuple structs"),
    };

    const res = try ctx.createArray(len);

    // loop unroll vectors, tuples and small arrays
    if (ti == .vector or ti == .@"struct" or (ti == .array and len <= 16)) {
        var nvs: [len]n.napi_value = undefined;
        inline for (0..len) |i| nvs[i] = try ctx.createNapiValue(val[i]);
        inline for (0..len) |i| try ctx.setElement(res, i, nvs[i]);
    } else {
        for (0..len) |i| try ctx.setElement(res, i, try ctx.createNapiValue(val[i]));
    }

    return res;
}

pub fn createObjectFrom(ctx: *const Ctx, val: anytype) !n.napi_value {
    const T = @TypeOf(val);
    const field_names = switch (@typeInfo(T)) {
        .@"struct" => comptime std.meta.fieldNames(T),
        else => @compileError("Can only create objects from structs"),
    };

    const res = try ctx.createObject();

    var nvks: [field_names.len]n.napi_value = undefined;
    inline for (field_names, 0..) |name, i| nvks[i] = try ctx.createStringUtf8(name);

    var nvvs: [field_names.len]n.napi_value = undefined;
    inline for (field_names, 0..) |name, i| nvvs[i] = try ctx.createNapiValue(@field(val, name));

    inline for (0..field_names.len) |i| try ctx.setProperty(res, nvks[i], nvvs[i]);

    return res;
}

pub fn createUnion(ctx: *const Ctx, val: anytype) !n.napi_value {
    if (@typeInfo(@TypeOf(val)) != .@"union") @compileError("Expected a union, got " ++ @typeName(@TypeOf(val)));

    const res = try ctx.createObject();
    switch (val) {
        inline else => try ctx.setNamedProperty(res, @tagName(val), try ctx.createNapiValue(val)),
    }
    return res;
}

fn checkCtxCallback(comptime T: type) void {
    const ti = switch (@typeInfo(T)) {
        .@"fn" => |f| f,
        else => @compileError("Expected a function type, got " ++ @typeName(T)),
    };

    if (ti.is_generic) @compileError("Cannot create callbacks from generic functions");
    if (ti.is_var_args) @compileError("Cannot create callbacks from varargs functions");
    if (ti.params.len != 2) @compileError("Cannot create callbacks from functions with less or more than 2 parameters");

    if (ti.params[0].type != *const Ctx) @compileError("Cannot create callbacks from functions with the first parameter not being a pointer to Ctx");
    if (ti.params[1].type != n.napi_callback_info) @compileError("Cannot create callbacks from functions with the second parameter not being a napi_callback_info");
}

pub fn createFunction(ctx: *const Ctx, f: anytype, comptime name: ?[]const u8, data: ?*anyopaque) !n.napi_value {
    const T = @TypeOf(f);
    checkCtxCallback(T);
    const return_type = @typeInfo(@typeInfo(T).@"fn".return_type.?);

    const wrapper = struct {
        pub fn cb(env: n.napi_env, cbi: n.napi_callback_info) callconv(.C) n.napi_value {
            var c: *const Ctx = undefined;
            napi_errors.statusToError(shim.napi_get_instance_data(@ptrCast(env), @ptrCast(&c))) catch @panic("napi_get_instance_data failed");
            const res = f(c, cbi);

            return c.createNapiValue(switch (return_type) {
                .error_union => res catch |e| {
                    c.throwError(null, @errorName(e)) catch @panic("throwError failed");
                    return null;
                },
                else => res,
            }) catch |e| {
                c.throwError(null, @errorName(e)) catch @panic("throwError failed");
                return null;
            };
        }
    };

    var result: n.napi_value = undefined;
    if (name) |name2| {
        try napi_errors.statusToError(shim.napi_create_function(@ptrCast(ctx.env), name2.ptr, name2.len, wrapper.cb, data, &result));
    } else {
        try napi_errors.statusToError(shim.napi_create_function(@ptrCast(ctx.env), null, 0, wrapper.cb, data, &result));
    }

    return result;
}

pub fn createNapiValue(ctx: *const Ctx, val: anytype) napi_errors.napi_error!n.napi_value {
    const T = @TypeOf(val);
    if (T == n.napi_value) return val;

    return switch (@typeInfo(T)) {
        .undefined => ctx.undefined,
        .null => ctx.null,
        .int => try ctx.createInt(val),
        .float => try ctx.createFloat(val),
        .@"union" => try ctx.createUnion(val),
        .bool => if (val) ctx.true else ctx.false,
        .array, .vector => try ctx.createArrayFrom(val),
        .@"fn" => try ctx.createFunction(val, null, null),
        .@"enum", .enum_literal => try ctx.createU32(@intFromEnum(val)),
        .optional => if (val) |v| try ctx.createNapiValue(v) else ctx.null,
        .@"struct" => |s| if (s.is_tuple) try ctx.createArrayFrom(val) else ctx.createObjectFrom(val),
        .pointer => |p| switch (p.size) {
            .Slice => try ctx.createArrayFrom(val),
            .One => {
                const ci = @typeInfo(p.child);
                if (ci == .array and ci.array.child == u8 and ci.array.sentinel != null and @as(*const u8, @ptrCast(ci.array.sentinel)).* == 0) {
                    return try ctx.createStringUtf8(val);
                }
                @compileError("Cannot convert pointer of size one to napi_value");
            },
            .C, .Many => @compileError("Cannot convert pointer of size " ++ @tagName(p.size) ++ " to napi_value"),
        },

        .comptime_float, .comptime_int => @compileError("Cannot convert " ++ @typeName(T) ++ " to napi_value, please cast to a real type"),
        .type, .void, .noreturn, .@"opaque", .@"anyframe", .frame, .error_union, .error_set => @compileError("Cannot convert type " ++ @typeName(T) ++ " to napi_value"),
    };
}
