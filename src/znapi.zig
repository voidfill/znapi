pub const napi = @import("napi_types.zig");
pub const Ctx = @import("ctx.zig");

test "refAllDecls" {
    @import("std").testing.refAllDeclsRecursive(@This());
}

pub fn defineModule(comptime exports: anytype) void {
    if (@typeInfo(@TypeOf(exports)) != .@"struct") {
        @compileError("Expected a struct, got: " ++ @typeName(@TypeOf(exports)));
    }

    const wrapper = struct {
        fn init(env: napi.napi_env, e: napi.napi_value) callconv(.C) napi.napi_value {
            const ctx = Ctx.init(env) catch return e;

            const asNapiValue = ctx.createObjectFrom(exports) catch return e;
            ctx.objectAssign(e, asNapiValue) catch return e;

            return e;
        }
    };

    @export(&wrapper.init, .{ .name = "napi_register_module_v1", .linkage = .strong });
}
