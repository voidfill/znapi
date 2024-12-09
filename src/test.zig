const std = @import("std");
const napi_types = @import("napi_types.zig");
const napi_functions = @import("napi_functions.zig");
const raw = @import("shim.zig");
const ctx = @import("ctx.zig");
const znapi = @import("znapi.zig");

test "refAllDecls" {
    std.testing.refAllDeclsRecursive(napi_types);
    std.testing.refAllDeclsRecursive(napi_functions);
    std.testing.refAllDeclsRecursive(raw);
    std.testing.refAllDeclsRecursive(ctx);
    std.testing.refAllDeclsRecursive(znapi);
}
