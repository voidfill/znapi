const std = @import("std");
const napi = @import("napi_types.zig");

pub const napi_error = error{ invalid_arg, object_expected, string_expected, name_expected, function_expected, number_expected, boolean_expected, array_expected, generic_failure, pending_exception, cancelled, escape_called_twice, handle_scope_mismatch, callback_scope_mismatch, queue_full, closing, bigint_expected, date_expected, arraybuffer_expected, detachable_arraybuffer_expected, would_deadlock, no_external_buffers_allowed, cannot_run_js };

const error_map = blk: {
    var arr = [_]napi_error{napi_error.generic_failure} ** std.meta.fieldNames(napi.napi_status).len;

    for (std.meta.fieldNames(napi_error)) |name| {
        const status = @field(napi.napi_status, name);
        arr[@intFromEnum(status)] = @field(napi_error, name);
    }

    break :blk arr;
};

pub fn statusToError(status: napi.napi_status) napi_error!void {
    switch (status) {
        .ok => return,
        inline else => return error_map[@intFromEnum(status)],
    }
}
