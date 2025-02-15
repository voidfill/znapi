const builtin = @import("builtin");
const std = @import("std");
const n = @import("napi_types.zig");
const shim = @import("shim.zig");
const napi_errors = @import("errors.zig");
const Ctx = @import("ctx.zig");

pub fn getValueInt(ctx: *const Ctx, comptime T: type, value: n.value) !T {
    const ti = switch (@typeInfo(T)) {
        .int => |i| i,
        else => @compileError("Expected an integer type, got: " ++ @typeName(T)),
    };

    if (ti.bits >= 64) {
        const wc = (ti.bits - 1) / 64 + 1;
        var wcc: usize = wc;
        var words: [wc]u64 align(@alignOf(T)) = [_]u64{0} ** wc;
        var sign: c_int = undefined;
        try napi_errors.statusToError(shim.napi_get_value_bigint_words(ctx.env, value, &sign, &wcc, &words));

        if (comptime builtin.cpu.arch.endian() != .little) @compileError("Bigint conversion not implemented for big endian");

        const ret = @as(*T, @ptrCast(&words)).*;
        return if (ti.signedness == .signed and sign != 0) -ret else ret;
    }

    if (ti.signedness == .unsigned) {
        return @intCast(try ctx.getValueU32(value));
    } else {
        return @intCast(try ctx.getValueI32(value));
    }
}

pub fn getValueFloat(ctx: *const Ctx, comptime T: type, value: n.value) !T {
    if (@typeInfo(T) != .float) @compileError("Expected a float type, got: " ++ @typeName(T));
    return @floatCast(try ctx.getValueDouble(value));
}

pub fn getValueArray(ctx: *const Ctx, comptime T: type, value: n.value, comptime allocator: ?std.mem.Allocator) !T {
    const ti = @typeInfo(T);
    const len = switch (ti) {
        inline .array, .vector => |t| t.len,
        .@"struct" => |s| if (s.is_tuple) comptime std.meta.fields(T).len else @compileError("Can only create arrays from structs that are tuples"),
        .pointer => |p| if (p.size == .slice) try ctx.getArrayLength(value) else @compileError("Can only create arrays from pointers of type slice"),
        else => @compileError("Can only create arrays from slices, arrays, vectors and tuple structs"),
    };

    var ret: switch (ti) {
        .pointer => |p| @Type(.{ .pointer = .{
            .size = p.size,
            .is_volatile = p.is_volatile,
            .alignment = p.alignment,
            .child = p.child,
            .sentinel_ptr = p.sentinel_ptr,
            .is_allowzero = p.is_allowzero,
            .address_space = p.address_space,

            .is_const = false,
        } }),
        else => T,
    } = switch (ti) {
        .array, .vector, .@"struct" => undefined,
        .pointer => |p| if (allocator) |a| switch (p.sentinel() == null) {
            true => try a.alloc(p.child, len),
            false => try a.allocSentinel(p.child, len, @as(*const p.child, @ptrCast(p.sentinel())).*),
        } else @compileError("Converting a napi_value to a slice requires an allocator"),
        else => @compileError("How did we get here?"),
    };

    if (ti == .@"struct") {
        var nvs: [len]n.value = undefined;
        inline for (0..len) |i| nvs[i] = try ctx.getElement(value, i);
        inline for (0..len) |i| ret[i] = try ctx.getValue(ti.@"struct".fields[i].type, nvs[i], allocator);

        return ret;
    }

    const child = switch (ti) {
        inline else => |t| t.child,
    };

    if (ti == .vector or (ti == .array and len <= 16)) {
        var nvs: [len]n.value = undefined;
        inline for (0..len) |i| nvs[i] = try ctx.getElement(value, i);
        inline for (0..len) |i| ret[i] = try ctx.getValue(child, nvs[i], allocator);
    } else {
        for (0..len) |i| ret[i] = try ctx.getValue(child, try ctx.getElement(value, i), allocator);
    }

    return ret;
}

pub fn getValueStruct(ctx: *const Ctx, comptime T: type, value: n.value, comptime allocator: ?std.mem.Allocator) !T {
    const ti = switch (@typeInfo(T)) {
        .@"struct" => |s| s,
        else => @compileError("Expected a struct type, got " ++ @typeName(T)),
    };

    var res: T = undefined;
    inline for (ti.fields) |field| {
        @field(res, field.name) = try ctx.getValue(field.type, try ctx.getNamedProperty(value, field.name), allocator);
    }
    return res;
}

fn getMaxUnionFieldNameLength(comptime T: type) usize {
    var max: usize = 0;
    inline for (@typeInfo(T).@"union".fields) |field| {
        if (max < field.name.len) max = field.name.len;
    }
    return max;
}

pub fn getValueUnion(ctx: *const Ctx, comptime T: type, value: n.value, comptime allocator: ?std.mem.Allocator) !T {
    const ti = switch (@typeInfo(T)) {
        .@"union" => |u| u,
        else => @compileError("Expected a union type, got " ++ @typeName(T)),
    };

    // 1 for null terminator, 1 extra so we dont think a and ab are the same
    var buffer: [getMaxUnionFieldNameLength(T) + 2]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const fba_alloc = fba.allocator();

    const prop_names = try ctx.getAllPropertyNames(value, n.key_collection_mode.own_only, n.key_filter.only_enumerable, n.key_conversion.numbers_to_strings);
    const len = try ctx.getArrayLength(prop_names);
    if (len != 1) return conversion_error.InvalidUnion;
    const active_field = try ctx.getValueStringUtf8(try ctx.getElement(prop_names, 0), fba_alloc);
    defer fba_alloc.free(active_field);

    inline for (ti.fields) |field| {
        if (std.mem.eql(u8, field.name, active_field)) {
            return @unionInit(T, field.name, try ctx.getValue(field.type, try ctx.getNamedProperty(value, field.name), allocator));
        }
    }

    return conversion_error.InvalidUnion;
}

const conversion_error = error{ NullExpected, InvalidUnion, OutOfMemory } || napi_errors.napi_error;
pub fn getValue(ctx: *const Ctx, comptime T: type, value: n.value, comptime allocator: ?std.mem.Allocator) conversion_error!T {
    if (T == n.value) return value;

    return switch (@typeInfo(T)) {
        // im  not sure why you would want to parse to a value that is unrepresentable but i don think there is any meaningful processing to be done here.
        .undefined => undefined,
        .null => if (try ctx.typeOf(value) == .null) null else conversion_error.NullExpected,
        .bool => try ctx.getValueBool(value),
        .optional => |o| switch (try ctx.typeOf(value)) {
            .undefined, .null => null,
            else => try ctx.getValue(o.child, value, allocator),
        },
        .int => try ctx.getValueInt(T, value),
        .float => try ctx.getValueFloat(T, value),
        inline .array, .vector => try ctx.getValueArray(T, value, allocator),
        .@"struct" => |s| if (s.is_tuple) try ctx.getValueArray(T, value, allocator) else ctx.getValueStruct(T, value, allocator),
        .pointer => |p| switch (p.size) {
            .slice => {
                if (allocator) |a| {
                    if (p.child == u8 and if (p.sentinel()) |s| s == 0 else false) {
                        return try ctx.getValueStringUtf8(value, a);
                    }
                    return try ctx.getValueArray(T, value, a);
                } else @compileError("Converting a javascript value to a slice requires an allocator");
            },
            else => @compileError("Cannot get value for a pointer of size " ++ @tagName(p.size) ++ ", " ++ @typeName(T)),
        },
        .@"enum" => @enumFromInt(try ctx.getValueU32(value)),
        .@"union" => try ctx.getValueUnion(T, value, allocator),

        .void => {},
        .type, .@"fn", .noreturn, .@"opaque", .@"anyframe", .frame, .error_set, .comptime_float, .comptime_int, .enum_literal, .error_union => @compileError("Cannot convert to type " ++ @typeName(T)),
    };
}
