const std = @import("std");
const n = @import("napi_types.zig");
const shim = @import("shim.zig");
const napi_errors = @import("errors.zig");
const Ctx = @import("ctx.zig");

pub fn getValueInt(ctx: *const Ctx, comptime T: type, value: n.napi_value) !T {
    const ti = switch (@typeInfo(T)) {
        .int => |i| i,
        else => @compileError("Expected an integer type, got: " ++ @typeName(T)),
    };

    if (ti.bits > 64) {
        const wc = (ti.bits - 1) / 64 + 1;
        var words: [wc]u64 align(@alignOf(T)) = undefined;
        var sign: c_int = undefined;
        try napi_errors.statusToError(shim.napi_get_value_bigint_words(ctx.env, value, &sign, &wc, &words));

        if (std.builtin.endian != .little) @compileError("Bigint conversion not implemented for big endian");

        const ret = @as(*T, @ptrCast(&words));
        return if (ti.signedness == .signed and sign != 0) -ret else ret;
    }

    if (ti.signedness == .unsigned) {
        return @intCast(if (ti.bits <= 32) try ctx.getValueU32(value) else try ctx.getValueBigintU64(value));
    } else {
        return @intCast(if (ti.bits <= 32) try ctx.getValueI32(value) else try ctx.getValueBigintI64(value));
    }
}

pub fn getValueFloat(ctx: *const Ctx, comptime T: type, value: n.napi_value) !T {
    if (@typeInfo(T) != .float) @compileError("Expected a float type, got: " ++ @typeName(T));
    return @floatCast(try ctx.getValueDouble(value));
}

pub fn getValueArray(ctx: *const Ctx, comptime T: type, value: n.napi_value, comptime allocator: ?std.mem.Allocator) !T {
    const ti = @typeInfo(T);
    const len = switch (ti) {
        inline .array, .vector => |t| t.len,
        .@"struct" => |s| if (s.is_tuple) comptime std.meta.fields(T).len else @compileError("Can only create arrays from structs that are tuples"),
        .pointer => |p| if (p.size == .Slice) try ctx.getArrayLength(value) else @compileError("Can only create arrays from pointers of type slice"),
        else => @compileError("Can only create arrays from slices, arrays, vectors and tuple structs"),
    };

    var ret: switch (ti) {
        .pointer => |p| @Type(.{ .pointer = .{
            .size = p.size,
            .is_volatile = p.is_volatile,
            .alignment = p.alignment,
            .child = p.child,
            .sentinel = p.sentinel,
            .is_allowzero = p.is_allowzero,
            .address_space = p.address_space,

            .is_const = false,
        } }),
        else => T,
    } = switch (ti) {
        .array, .vector, .@"struct" => undefined,
        .pointer => |p| if (allocator) |a| switch (p.sentinel == null) {
            true => try a.alloc(p.child, len),
            false => try a.allocSentinel(p.child, len, @as(*const p.child, @ptrCast(p.sentinel)).*),
        } else @compileError("Converting a napi_value to a slice requires an allocator"),
        else => @compileError("How did we get here?"),
    };

    if (ti == .@"struct") {
        var nvs: [len]n.napi_value = undefined;
        inline for (0..len) |i| nvs[i] = try ctx.getElement(value, i);
        inline for (0..len) |i| ret[i] = try ctx.getValue(ti.@"struct".fields[i].type, nvs[i], allocator);

        return ret;
    }

    const child = switch (ti) {
        inline else => |t| t.child,
    };

    if (ti == .vector or (ti == .array and len <= 16)) {
        var nvs: [len]n.napi_value = undefined;
        inline for (0..len) |i| nvs[i] = try ctx.getElement(value, i);
        inline for (0..len) |i| ret[i] = try ctx.getValue(child, nvs[i], allocator);
    } else {
        for (0..len) |i| ret[i] = try ctx.getValue(child, try ctx.getElement(value, i), allocator);
    }

    return ret;
}

const conversion_error = error{ UndefinedExpected, NullExpected } || napi_errors.napi_error;
pub fn getValue(ctx: *const Ctx, comptime T: type, value: n.napi_value, allocator: ?std.mem.Allocator) conversion_error!T {
    if (T == n.napi_value) return value;

    return switch (@typeInfo(T)) {
        .undefined => if (try ctx.typeOf(value) == .undefined) ctx.undefined else conversion_error.UndefinedExpected,
        .null => if (try ctx.typeOf(value) == .null) ctx.null else conversion_error.NullExpected,
        .bool => try ctx.getValueBool(value),
        .optional => |o| switch (try ctx.typeOf(value)) {
            .undefined, .null => null,
            else => try ctx.getValue(o.child, value, allocator),
        },
        .int => try ctx.getValueInt(T, value),
        .float => try ctx.getValueFloat(T, value),
        inline .array, .vector => try ctx.getValueArray(T, value, allocator),
        .@"struct" => |s| if (s.is_tuple) try ctx.getValueArray(T, value, allocator) else @compileError("TODO: implement struct conversion"),
        .pointer => |p| switch (p.size) {
            .Slice => {},
            else => @compileError("Cannot get value for a pointer of size " ++ @tagName(p.size) ++ ", " ++ @typeName(T)),
        },
        .@"enum" => @enumFromInt(try ctx.getValueU32(value)),

        .type, .@"fn", .void, .noreturn, .@"opaque", .@"anyframe", .frame, .error_set, .comptime_float, .comptime_int => @compileError("Cannot convert to type " ++ @typeName(T)),
        else => @compileError("bwa"),
    };
}
