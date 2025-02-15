const znapi = @import("znapi");
const std = @import("std");

const arr = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
const sl: []const u8 = arr[1..3];
const str = ([_]u8{ 'a', 'b', 'c', 0 })[0..3 :0];

const un = union(enum) { a, aa, b: i365 };

const en = enum(u8) {
    a = 42,
    _,
};

fn testParseTo(comptime T: type, comptime val: T) fn (ctx: *const znapi.Ctx, cbi: znapi.napi.callback_info) anyerror!T {
    const wrapper = struct {
        pub fn f(ctx: *const znapi.Ctx, cbi: znapi.napi.callback_info) anyerror!T {
            const c = try ctx.getCallbackArgs(cbi, 1);

            const parsed = try ctx.getValue(T, c[0], std.heap.page_allocator);

            switch (@typeInfo(T)) {
                .pointer => |p| switch (p.size) {
                    .slice => {
                        if (std.mem.eql(u8, parsed, val)) {
                            return parsed;
                        } else {
                            return error.TestExpectedEqual;
                        }
                    },
                    else => {},
                },
                else => try std.testing.expectEqual(val, parsed),
            }

            return parsed;
        }
    };

    return wrapper.f;
}

comptime {
    znapi.defineModule(.{
        .integers = .{
            .u0 = @as(u0, 0),
            .u1 = @as(u1, 1),
            .i1 = @as(i1, -1),
            .u32 = @as(u32, 3),
            .i32 = @as(i32, -3),

            .pu0 = testParseTo(u0, 0),
            .pu1 = testParseTo(u1, 1),
            .pi1 = testParseTo(i1, -1),
            .pu32 = testParseTo(u32, 3),
            .pi32 = testParseTo(i32, -3),
        },
        .bigints = .{
            .u64 = @as(u64, 3),
            .i64 = @as(i64, -3),
            .u128 = @as(u128, 3),
            .u1234 = @as(u1234, 3),
            .i1234 = @as(i1234, -3),

            .pu64 = testParseTo(u64, 3),
            .pi64 = testParseTo(i64, -3),
            .pu128 = testParseTo(u128, 3),
            .pu1234 = testParseTo(u1234, 3),
            .pi1234 = testParseTo(i1234, -3),
        },
        .floats = .{
            .f16 = @as(f16, 3.14),
            .f32 = @as(f32, 3.14),
            .f64 = @as(f64, 3.14),

            .pf16 = testParseTo(f16, 3.14),
            .pf32 = testParseTo(f32, 3.14),
            .pf64 = testParseTo(f64, 3.14),
        },
        .undefined = undefined,
        .null = .{
            .null = null,
            .pnull = testParseTo(?u0, null),
        },
        .bools = .{
            .true = true,
            .false = false,
            .ptrue = testParseTo(bool, true),
            .pfalse = testParseTo(bool, false),
        },
        .strings = .{
            .empty = "",
            .single = "a",
            .multi = "abc",
            .multi_utf8 = "😀😁😂🤣😃😄😅😆😉😊😋😎😍😘🥰😗😙😚",

            .psingle = testParseTo([:0]const u8, "a"),
            .pmulti = testParseTo([:0]const u8, "abc"),
            .pmulti_utf8 = testParseTo([:0]const u8, "😀😁😂🤣😃😄😅😆😉😊😋😎😍😘🥰😗😙😚"),
        },
        .arrays = .{
            .empty = [_]u8{},
            .single = [_]u8{1},
            .multi = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
            .large = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
            .vector = @Vector(10, u8){ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
            .tuple = struct { u8, u123, u7 }{ 1, 2, 3 },
            .slice = sl,

            .pempty = testParseTo([]const u8, &[_]u8{}),
            .psingle = testParseTo([]const u8, &[_]u8{1}),
            .pmulti = testParseTo([]const u8, &[_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }),
            .plarge = testParseTo([]const u8, &[_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }),
            .pvector = testParseTo(@Vector(10, u8), @Vector(10, u8){ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }),
            .ptuple = testParseTo([]const u8, &[_]u8{ 1, 2, 3 }),
            .pslice = testParseTo([]const u8, sl),
        },
        .structs = .{
            .single = .{ .a = @as(u8, 1) },
            .multi = .{ .a = @as(u8, 1), .b = @as(u8, 2), .c = @as(u8, 3), .d = @as(u8, 4), .e = @as(u8, 5), .f = @as(u8, 6), .g = @as(u8, 7), .h = @as(u8, 8), .i = @as(u8, 9), .j = @as(u8, 10) },

            .psingle = testParseTo(struct { a: u8 }, .{ .a = 1 }),
            .pmulti = testParseTo(struct { a: u8, b: u8, c: u8, d: u8, e: u8, f: u8, g: u8, h: u8, i: u8, j: u8 }, .{ .a = 1, .b = 2, .c = 3, .d = 4, .e = 5, .f = 6, .g = 7, .h = 8, .i = 9, .j = 10 }),
        },
        .unions = .{
            .un1 = un{ .a = undefined },
            .un2 = un{ .aa = undefined },
            .un3 = un{ .b = 2431 },

            .pun1 = testParseTo(un, .{ .a = {} }),
            .pun2 = testParseTo(un, .{ .aa = {} }),
            .pun3 = testParseTo(un, .{ .b = 2431 }),
        },
        .optionals = .{
            .empty = @as(?u8, null),
            .filled = @as(?u8, 1),

            .pempty = testParseTo(?u8, null),
            .pfilled = testParseTo(?u8, 1),
        },
        .enums = .{
            .en1 = @as(en, .a),
            .en2 = @as(en, @enumFromInt(123)),

            .pen1 = testParseTo(en, .a),
            .pen2 = testParseTo(en, @enumFromInt(123)),
        },
    });
}
