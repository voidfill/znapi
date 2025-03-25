/// Collection of dumb wrappers around shim.zig meant to provide error handling at low cognitive load
const std = @import("std");
const n = @import("napi_types.zig");
const napi_errors = @import("errors.zig");
const shim = @import("shim.zig");

const err = napi_errors.statusToError;
const v = n.value;

/// allows either passing a napi_env or a struct with field env
inline fn _env(e: anytype) n.env {
    return if (comptime @TypeOf(e) == n.env) e else e.env;
}

//

pub fn toBool(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_bool(_env(e), value, &result));
    return result;
}

pub fn toNumber(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_number(_env(e), value, &result));
    return result;
}

pub fn toObject(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_object(_env(e), value, &result));
    return result;
}

pub fn toString(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_string(_env(e), value, &result));
    return result;
}

pub fn createArray(e: anytype, len: ?usize) !v {
    var result: v = undefined;
    try err(if (len) |l| shim.napi_create_array_with_length(_env(e), l, &result) else shim.napi_create_array(_env(e), &result));
    return result;
}

pub fn createBigintI64(e: anytype, value: i64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_int64(_env(e), value, &result));
    return result;
}

pub fn createBigintU64(e: anytype, value: u64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_uint64(_env(e), value, &result));
    return result;
}

pub fn createBigintWords(e: anytype, sign_bit: bool, words: []const u64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_words(_env(e), @intFromBool(sign_bit), words.len, words.ptr, &result));
    return result;
}

pub fn createDataview(e: anytype, length: usize, array_buffer: v, offset: usize) !v {
    var result: v = undefined;
    try err(shim.napi_create_dataview(_env(e), length, array_buffer, offset, &result));
    return result;
}

pub fn createDate(e: anytype, time: f64) !v {
    var result: v = undefined;
    try err(shim.napi_create_date(_env(e), time, &result));
    return result;
}

pub fn createDouble(e: anytype, value: f64) !v {
    var result: v = undefined;
    try err(shim.napi_create_double(_env(e), value, &result));
    return result;
}

pub fn createError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_error(_env(e), code, msg, &result));
    return result;
}

pub fn createI32(e: anytype, value: i32) !v {
    var result: v = undefined;
    try err(shim.napi_create_int32(_env(e), value, &result));
    return result;
}

pub fn createI64(e: anytype, value: i64) !v {
    var result: v = undefined;
    try err(shim.napi_create_int64(_env(e), value, &result));
    return result;
}

pub fn createObject(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_create_object(_env(e), &result));
    return result;
}

pub fn createRangeError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_range_error(_env(e), code, msg, &result));
    return result;
}

pub fn createReference(e: anytype, value: v, initial_refcount: u32) !n.ref {
    var result: n.ref = undefined;
    try err(shim.napi_create_reference(_env(e), value, initial_refcount, &result));
    return result;
}

pub fn createStringLatin1(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_latin1(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn createStringUtf16(e: anytype, str: []const u16) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_utf16(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn createStringUtf8(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_utf8(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn createSymbol(e: anytype, description: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_symbol(_env(e), description, &result));
    return result;
}

pub fn createTypeError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_type_error(_env(e), code, msg, &result));
    return result;
}

pub fn createU32(e: anytype, value: u32) !v {
    var result: v = undefined;
    try err(shim.napi_create_uint32(_env(e), value, &result));
    return result;
}

pub fn defineProperties(e: anytype, object: v, properties: []const n.property_descriptor) !void {
    try err(shim.napi_define_properties(_env(e), object, properties.len, properties.ptr));
}

pub fn deleteElement(e: anytype, object: v, index: usize) !bool {
    var result: bool = undefined;
    try err(shim.napi_delete_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn deleteProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_delete_property(_env(e), object, key, &result));
    return result;
}

pub fn deleteReference(e: anytype, ref: n.ref) !void {
    try err(shim.napi_delete_reference(_env(e), ref));
}

pub fn detachArraybuffer(e: anytype, arraybuffer: v) !void {
    try err(shim.napi_detach_arraybuffer(_env(e), arraybuffer));
}

pub fn escapeHandle(e: anytype, scope: n.escapable_handle_scope, escapee: v) !v {
    var result: v = undefined;
    try err(shim.napi_escape_handle(_env(e), scope, escapee, &result));
    return result;
}

pub fn fatalError(e: anytype, location: []const u8, message: []const u8) noreturn {
    shim.napi_fatal_error(_env(e), location.ptr, location.len, message.ptr, message.len);
}

pub fn fatalException(e: anytype, er: v) !void {
    try err(shim.napi_fatal_exception(_env(e), er));
}

pub fn getAllPropertyNames(e: anytype, object: v, key_mode: n.key_collection_mode, key_filter: n.key_filter, key_conversion: n.key_conversion) !v {
    var result: v = undefined;
    try err(shim.napi_get_all_property_names(_env(e), object, key_mode, key_filter, key_conversion, &result));
    return result;
}

pub fn getAndClearLastException(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_and_clear_last_exception(_env(e), &result));
    return result;
}

pub fn getArrayLength(e: anytype, value: v) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_array_length(_env(e), value, &result));
    return result;
}

pub fn getBoolean(e: anytype, value: bool) !v {
    var result: v = undefined;
    try err(shim.napi_get_boolean(_env(e), value, &result));
    return result;
}

pub fn getBufferInfo(e: anytype, value: v) ![]const u8 {
    var data: ?*anyopaque = undefined;
    var length: usize = undefined;
    try err(shim.napi_get_buffer_info(_env(e), value, &data, &length));

    if (length == 0 or data == null) return &[0]u8{};

    return @as([*]const u8, @ptrCast(data))[0..length];
}

pub fn getCallbackArgs(e: anytype, cbi: n.callback_info, comptime argc: usize) ![argc]v {
    var args: [argc]v = undefined;
    var argcc = argc;
    try err(shim.napi_get_cb_info(_env(e), cbi, &argcc, &args, null, null));
    return args;
}

pub fn getCallbackData(e: anytype, cbi: n.callback_info) !?*anyopaque {
    var data: ?*anyopaque = undefined;
    try err(shim.napi_get_cb_info(_env(e), cbi, null, null, null, &data));
    return data;
}

pub fn getDateValue(e: anytype, value: v) !f64 {
    var result: f64 = undefined;
    try err(shim.napi_get_date_value(_env(e), value, &result));
    return result;
}

pub fn getElement(e: anytype, object: v, index: usize) !v {
    var result: v = undefined;
    try err(shim.napi_get_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn getGlobal(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_global(_env(e), &result));
    return result;
}

pub fn getInstanceData(e: anytype) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_get_instance_data(_env(e), &result));
    return result;
}

pub fn getLastErrorInfo(e: anytype) !*const n.extended_error_info {
    var result: *const n.napi_extended_error_nfo = undefined;
    try err(shim.napi_get_last_error_info(_env(e), &result));
    return result;
}

pub fn getNamedProperty(e: anytype, object: v, utf8name: [:0]const u8) !v {
    var result: v = undefined;
    try err(shim.napi_get_named_property(_env(e), object, utf8name.ptr, &result));
    return result;
}

pub fn getNewTarget(e: anytype, cbinfo: n.callback_info) !v {
    var result: v = undefined;
    try err(shim.napi_get_new_target(_env(e), cbinfo, &result));
    return result;
}

pub fn getNodeVersion(e: anytype) !*n.node_version {
    var result: *n.node_version = undefined;
    try err(shim.napi_get_node_version(_env(e), &result));
    return result;
}

pub fn getNull(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_null(_env(e), &result));
    return result;
}

pub fn getProperty(e: anytype, object: v, key: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_property(_env(e), object, key, &result));
    return result;
}

pub fn getPropertyNames(e: anytype, object: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_property_names(_env(e), object, &result));
    return result;
}

pub fn getPrototype(e: anytype, object: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_prototype(_env(e), object, &result));
    return result;
}

pub fn getReferenceValue(e: anytype, ref: n.ref) !v {
    var result: v = undefined;
    try err(shim.napi_get_reference_value(_env(e), ref, &result));
    return result;
}

pub fn getUndefined(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_undefined(_env(e), &result));
    return result;
}

pub fn getUvEventLoop(e: anytype) !*n.struct_uv_loop_s {
    var result: *n.struct_uv_loop_s = undefined;
    try err(shim.napi_get_uv_event_loop(_env(e), &result));
    return result;
}

pub fn getValueBigintI64(e: anytype, value: v) !struct { lossless: bool, value: i64 } {
    var lossless: bool = undefined;
    var i: i64 = undefined;
    try err(shim.napi_get_value_bigint_int64(_env(e), value, &i, &lossless));
    return .{ .lossless = lossless, .value = i };
}

pub fn getValueBigintU64(e: anytype, value: v) !struct { lossless: bool, value: u64 } {
    var lossless: bool = undefined;
    var i: u64 = undefined;
    try err(shim.napi_get_value_bigint_uint64(_env(e), value, &i, &lossless));
    return .{ .lossless = lossless, .value = i };
}

pub fn getValueBigintWords(e: anytype, value: v, allocator: std.mem.Allocator) !struct { sign: bool, words: []const u64 } {
    var len: usize = undefined;
    try err(shim.napi_get_value_bigint_words(_env(e), value, null, &len, null));
    var words = try allocator.alloc(u64, len);
    var sign: c_int = undefined;
    try err(shim.napi_get_value_bigint_words(_env(e), value, &sign, &len, @ptrCast(&words)));
    return .{ .sign = sign != 0, .words = words };
}

pub fn getValueBool(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_get_value_bool(_env(e), value, &result));
    return result;
}

pub fn getValueDouble(e: anytype, value: v) !f64 {
    var result: f64 = undefined;
    try err(shim.napi_get_value_double(_env(e), value, &result));
    return result;
}

pub fn getValueExternal(e: anytype, value: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_get_value_external(_env(e), value, &result));
    return result;
}

pub fn getValueI32(e: anytype, value: v) !i32 {
    var result: i32 = undefined;
    try err(shim.napi_get_value_int32(_env(e), value, &result));
    return result;
}

pub fn getValueI64(e: anytype, value: v) !i64 {
    var result: i64 = undefined;
    try err(shim.napi_get_value_int64(_env(e), value, &result));
    return result;
}

pub fn getValueStringLatin1(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u8 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_latin1(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u8, len, 0);
    try err(shim.napi_get_value_string_latin1(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn getValueStringUtf16(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u16 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_utf16(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u16, len, 0);
    try err(shim.napi_get_value_string_utf16(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn getValueStringUtf8(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u8 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_utf8(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u8, len, 0);
    try err(shim.napi_get_value_string_utf8(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn getValueU32(e: anytype, value: v) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_value_uint32(_env(e), value, &result));
    return result;
}

pub fn getVersion(e: anytype) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_version(_env(e), &result));
    return result;
}

pub fn hasElement(e: anytype, object: v, index: usize) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn hasNamedProperty(e: anytype, object: v, utf8name: [:0]const u8) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_named_property(_env(e), object, utf8name.ptr, &result));
    return result;
}

pub fn hasOwnProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_own_property(_env(e), object, key, &result));
    return result;
}

pub fn hasProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_property(_env(e), object, key, &result));
    return result;
}

pub fn instanceOf(e: anytype, object: v, constructor: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_instanceof(_env(e), object, constructor, &result));
    return result;
}

pub fn isArray(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_array(_env(e), value, &result));
    return result;
}

pub fn isArraybuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_arraybuffer(_env(e), value, &result));
    return result;
}

pub fn isBuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_buffer(_env(e), value, &result));
    return result;
}

pub fn isDataview(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_dataview(_env(e), value, &result));
    return result;
}

pub fn isDate(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_date(_env(e), value, &result));
    return result;
}

pub fn isDetachedArraybuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_detached_arraybuffer(_env(e), value, &result));
    return result;
}

pub fn isError(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_error(_env(e), value, &result));
    return result;
}

pub fn isExceptionPending(e: anytype) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_exception_pending(_env(e), &result));
    return result;
}

pub fn isPromise(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_promise(_env(e), value, &result));
    return result;
}

pub fn isTypedArray(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_typedarray(_env(e), value, &result));
    return result;
}

pub fn newInstance(e: anytype, constructor: v, args: []const v) !v {
    var result: v = undefined;
    try err(shim.napi_new_instance(_env(e), constructor, args.len, args.ptr, &result));
    return result;
}

pub fn objectFreeze(e: anytype, object: v) !void {
    try err(shim.napi_object_freeze(_env(e), object));
}

pub fn objectSeal(e: anytype, object: v) !void {
    try err(shim.napi_object_seal(_env(e), object));
}

pub fn referenceRef(e: anytype, ref: n.ref) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_reference_ref(_env(e), ref, &result));
    return result;
}

pub fn referenceUnref(e: anytype, ref: n.ref) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_reference_unref(_env(e), ref, &result));
    return result;
}

pub fn removeWrap(e: anytype, js_object: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_remove_wrap(_env(e), js_object, &result));
    return result;
}

pub fn runScript(e: anytype, script: v) !v {
    var result: v = undefined;
    try err(shim.napi_run_script(_env(e), script, &result));
    return result;
}

pub fn setElement(e: anytype, object: v, index: usize, value: v) !void {
    try err(shim.napi_set_element(_env(e), object, @truncate(index), value));
}

pub fn setNamedProperty(e: anytype, object: v, utf8name: [:0]const u8, value: v) !void {
    try err(shim.napi_set_named_property(_env(e), object, utf8name.ptr, value));
}

pub fn setProperty(e: anytype, object: v, key: v, value: v) !void {
    try err(shim.napi_set_property(_env(e), object, key, value));
}

pub fn strictEquals(e: anytype, lhs: v, rhs: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_strict_equals(_env(e), lhs, rhs, &result));
    return result;
}

pub fn throw(e: anytype, value: v) !void {
    switch (shim.napi_throw(_env(e), value)) {
        .ok, .pending_exception => {},
        else => |status| return err(status),
    }
}

pub fn throwError(e: anytype, code: ?[:0]const u8, msg: [:0]const u8) !void {
    switch (shim.napi_throw_error(_env(e), if (code) |c| c.ptr else null, msg.ptr)) {
        .ok, .pending_exception => {},
        else => |status| return err(status),
    }
}

pub fn throwRangeError(e: anytype, code: ?[:0]const u8, msg: [:0]const u8) !void {
    switch (shim.napi_throw_range_error(_env(e), if (code) |c| c.ptr else null, msg.ptr)) {
        .ok, .pending_exception => {},
        else => |status| return err(status),
    }
}

pub fn throwTypeError(e: anytype, code: ?[:0]const u8, msg: [:0]const u8) !void {
    switch (shim.napi_throw_type_error(_env(e), if (code) |c| c.ptr else null, msg.ptr)) {
        .ok, .pending_exception => {},
        else => |status| return err(status),
    }
}

pub fn typeTagObject(e: anytype, value: v, type_tag: n.type_tag) !void {
    try err(shim.napi_type_tag_object(_env(e), value, type_tag));
}

pub fn typeOf(e: anytype, value: v) !n.valuetype {
    var result: n.valuetype = undefined;
    try err(shim.napi_typeof(_env(e), value, &result));
    return result;
}

pub fn unwrap(e: anytype, js_object: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_unwrap(_env(e), js_object, &result));
    return result;
}

pub fn wrap(e: anytype, js_object: v, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque) !n.ref {
    var result: n.ref = undefined;
    try err(shim.napi_wrap(_env(e), js_object, native_object, finalize_cb, finalize_hint, &result));
    return result;
}

pub fn createPropertyKeyLatin1(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_latin1(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn createPropertyKeyUtf16(e: anytype, str: []const u16) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_utf16(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn createPropertyKeyUtf8(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_utf8(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn symbolFor(e: anytype, description: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_symbol_for(_env(e), description.ptr, description.len, &result));
    return result;
}
