pub const napi = @import("napi_types.zig");
pub const Ctx = @import("ctx.zig");
pub const errors = @import("errors.zig");
pub const raw = @import("shim.zig");

pub fn defineModule(comptime exports: anytype) void {
    if (@typeInfo(@TypeOf(exports)) != .@"struct") {
        @compileError("Expected a struct, got: " ++ @typeName(@TypeOf(exports)));
    }

    const wrapper = struct {
        fn init(env: napi.env, e: napi.value) callconv(.C) napi.value {
            const ctx = Ctx.create(env, @import("std").heap.page_allocator) catch return e;
            return ctx.createObjectFrom(exports) catch return e;
        }
    };

    @export(&wrapper.init, .{ .name = "napi_register_module_v1", .linkage = .strong });
}
