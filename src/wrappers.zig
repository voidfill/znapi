/// Collection of dumb wrappers around shim.zig meant to provide error handling at low cognitive load
const std = @import("std");
const n = @import("napi_types.zig");
const napi_errors = @import("errors.zig");
const shim = @import("shim.zig");

const err = napi_errors.statusToError;
const v = n.napi_value;

test "refAllDecls" {
    @import("std").testing.refAllDeclsRecursive(@This());
}

/// allows either passing a napi_env or a struct with field env
inline fn _env(e: anytype) n.napi_env {
    return if (comptime @TypeOf(e) == n.napi_env) e else e.env;
}

//

pub fn _toBool(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_bool(_env(e), value, &result));
    return result;
}

pub fn _toNumber(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_number(_env(e), value, &result));
    return result;
}

pub fn _toObject(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_object(_env(e), value, &result));
    return result;
}

pub fn _toString(e: anytype, value: v) !v {
    var result: v = undefined;
    try err(shim.napi_coerce_to_string(_env(e), value, &result));
    return result;
}

pub fn _createArray(e: anytype, len: ?usize) !v {
    var result: v = undefined;
    try err(if (len) |l| shim.napi_create_array_with_length(_env(e), l, &result) else shim.napi_create_array(_env(e), &result));
    return result;
}

pub fn _createBigintI64(e: anytype, value: i64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_int64(_env(e), value, &result));
    return result;
}

pub fn _createBigintU64(e: anytype, value: u64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_uint64(_env(e), value, &result));
    return result;
}

pub fn _createBigintWords(e: anytype, sign_bit: bool, words: []const u64) !v {
    var result: v = undefined;
    try err(shim.napi_create_bigint_words(_env(e), sign_bit, words.len, words.ptr, &result));
    return result;
}

pub fn _createDataview(e: anytype, length: usize, array_buffer: v, offset: usize) !v {
    var result: v = undefined;
    try err(shim.napi_create_dataview(_env(e), length, array_buffer, offset, &result));
    return result;
}

pub fn _createDate(e: anytype, time: f64) !v {
    var result: v = undefined;
    try err(shim.napi_create_date(_env(e), time, &result));
    return result;
}

pub fn _createDouble(e: anytype, value: f64) !v {
    var result: v = undefined;
    try err(shim.napi_create_double(_env(e), value, &result));
    return result;
}

pub fn _createError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_error(_env(e), code, msg, &result));
    return result;
}

pub fn _createI32(e: anytype, value: i32) !v {
    var result: v = undefined;
    try err(shim.napi_create_int32(_env(e), value, &result));
    return result;
}

pub fn _createI64(e: anytype, value: i64) !v {
    var result: v = undefined;
    try err(shim.napi_create_int64(_env(e), value, &result));
    return result;
}

pub fn _createObject(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_create_object(_env(e), &result));
    return result;
}

pub fn _createRangeError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_range_error(_env(e), code, msg, &result));
    return result;
}

pub fn _createReference(e: anytype, value: v, initial_refcount: u32) !n.napi_ref {
    var result: n.napi_ref = undefined;
    try err(shim.napi_create_reference(_env(e), value, initial_refcount, &result));
    return result;
}

pub fn _createStringLatin1(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_latin1(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _createStringUtf16(e: anytype, str: []const u16) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_utf16(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _createStringUtf8(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.napi_create_string_utf8(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _createSymbol(e: anytype, description: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_symbol(_env(e), description, &result));
    return result;
}

pub fn _createTypeError(e: anytype, code: v, msg: v) !v {
    var result: v = undefined;
    try err(shim.napi_create_type_error(_env(e), code, msg, &result));
    return result;
}

pub fn _createU32(e: anytype, value: u32) !v {
    var result: v = undefined;
    try err(shim.napi_create_uint32(_env(e), value, &result));
    return result;
}

pub fn _defineProperties(e: anytype, object: v, properties: []const n.napi_property_descriptor) !void {
    try err(shim.napi_define_properties(_env(e), object, properties.len, properties.ptr));
}

pub fn _deleteElement(e: anytype, object: v, index: usize) !bool {
    var result: bool = undefined;
    try err(shim.napi_delete_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn _deleteProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_delete_property(_env(e), object, key, &result));
    return result;
}

pub fn _deleteReference(e: anytype, ref: n.napi_ref) !void {
    try err(shim.napi_delete_reference(_env(e), ref));
}

pub fn _detachArraybuffer(e: anytype, arraybuffer: v) !void {
    try err(shim.napi_detach_arraybuffer(_env(e), arraybuffer));
}

pub fn _escapeHandle(e: anytype, scope: n.napi_escapable_handle_scope, escapee: v) !v {
    var result: v = undefined;
    try err(shim.napi_escape_handle(_env(e), scope, escapee, &result));
    return result;
}

pub fn _fatalError(e: anytype, location: []const u8, message: []const u8) !noreturn {
    shim.napi_fatal_error(_env(e), location.ptr, location.len, message.ptr, message.len);
}

pub fn _fatalException(e: anytype, er: v) !void {
    try err(shim.napi_fatal_exception(_env(e), er));
}

pub fn _getAllPropertyNames(e: anytype, object: v, key_mode: n.napi_key_collection_mode, key_filter: n.napi_key_filter, key_conversion: n.napi_key_conversion) !v {
    var result: v = undefined;
    try err(shim.napi_get_all_property_names(_env(e), object, key_mode, key_filter, key_conversion, &result));
    return result;
}

pub fn _getAndClearLastException(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_and_clear_last_exception(_env(e), &result));
    return result;
}

pub fn _getArrayLength(e: anytype, value: v) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_array_length(_env(e), value, &result));
    return result;
}

pub fn _getBoolean(e: anytype, value: bool) !v {
    var result: v = undefined;
    try err(shim.napi_get_boolean(_env(e), value, &result));
    return result;
}

pub fn _getDateValue(e: anytype, value: v) !f64 {
    var result: f64 = undefined;
    try err(shim.napi_get_date_value(_env(e), value, &result));
    return result;
}

pub fn _getElement(e: anytype, object: v, index: usize) !v {
    var result: v = undefined;
    try err(shim.napi_get_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn _getGlobal(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_global(_env(e), &result));
    return result;
}

pub fn _getInstanceData(e: anytype) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_get_instance_data(_env(e), &result));
    return result;
}

pub fn _getLastErrorInfo(e: anytype) !*const n.napi_extended_error_info {
    var result: *const n.napi_extended_error_nfo = undefined;
    try err(shim.napi_get_last_error_info(_env(e), &result));
    return result;
}

pub fn _getNamedProperty(e: anytype, object: v, utf8name: [:0]const u8) !v {
    var result: v = undefined;
    try err(shim.napi_get_named_property(_env(e), object, utf8name.ptr, &result));
    return result;
}

pub fn _getNewTarget(e: anytype, cbinfo: n.napi_callback_info) !v {
    var result: v = undefined;
    try err(shim.napi_get_new_target(_env(e), cbinfo, &result));
    return result;
}

pub fn _getNodeVersion(e: anytype) !*n.napi_node_version {
    var result: *n.napi_node_version = undefined;
    try err(shim.napi_get_node_version(_env(e), &result));
    return result;
}

pub fn _getNull(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_null(_env(e), &result));
    return result;
}

pub fn _getProperty(e: anytype, object: v, key: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_property(_env(e), object, key, &result));
    return result;
}

pub fn _getPropertyNames(e: anytype, object: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_property_names(_env(e), object, &result));
    return result;
}

pub fn _getPrototype(e: anytype, object: v) !v {
    var result: v = undefined;
    try err(shim.napi_get_prototype(_env(e), object, &result));
    return result;
}

pub fn _getReferenceValue(e: anytype, ref: n.napi_ref) !v {
    var result: v = undefined;
    try err(shim.napi_get_reference_value(_env(e), ref, &result));
    return result;
}

pub fn _getUndefined(e: anytype) !v {
    var result: v = undefined;
    try err(shim.napi_get_undefined(_env(e), &result));
    return result;
}

pub fn _getUvEventLoop(e: anytype) !*n.struct_uv_loop_s {
    var result: *n.struct_uv_loop_s = undefined;
    try err(shim.napi_get_uv_event_loop(_env(e), &result));
    return result;
}

pub fn _getValueBigintI64(e: anytype, value: v) !struct { lossless: bool, words: i64 } {
    var lossless: bool = undefined;
    var i: i64 = undefined;
    try err(shim.napi_get_value_bigint_int64(_env(e), value, &i, &lossless));
    return .{ .lossless = lossless, .words = i };
}

pub fn _getValueBigintU64(e: anytype, value: v) !struct { lossless: bool, words: u64 } {
    var lossless: bool = undefined;
    var i: u64 = undefined;
    try err(shim.napi_get_value_bigint_uint64(_env(e), value, &i, &lossless));
    return .{ .lossless = lossless, .words = i };
}

pub fn _getValueBigintWords(e: anytype, value: v, allocator: std.mem.Allocator) !struct { sign: bool, words: []const u64 } {
    var len: usize = undefined;
    try err(shim.napi_get_value_bigint_words(_env(e), value, null, &len, null));
    var words = try allocator.alloc(u64, len);
    var sign: c_int = undefined;
    try err(shim.napi_get_value_bigint_words(_env(e), value, &sign, &len, @ptrCast(&words)));
    return .{ .sign = sign != 0, .words = words };
}

pub fn _getValueBool(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_get_value_bool(_env(e), value, &result));
    return result;
}

pub fn _getValueDouble(e: anytype, value: v) !f64 {
    var result: f64 = undefined;
    try err(shim.napi_get_value_double(_env(e), value, &result));
    return result;
}

pub fn _getValueExternal(e: anytype, value: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_get_value_external(_env(e), value, &result));
    return result;
}

pub fn _getValueI32(e: anytype, value: v) !i32 {
    var result: i32 = undefined;
    try err(shim.napi_get_value_int32(_env(e), value, &result));
    return result;
}

pub fn _getValueI64(e: anytype, value: v) !i64 {
    var result: i64 = undefined;
    try err(shim.napi_get_value_int64(_env(e), value, &result));
    return result;
}

pub fn _getValueStringLatin1(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u8 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_latin1(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u8, len, 0);
    try err(shim.napi_get_value_string_latin1(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn _getValueStringUtf16(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u16 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_utf16(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u16, len, 0);
    try err(shim.napi_get_value_string_utf16(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn _getValueStringUtf8(e: anytype, value: v, allocator: std.mem.Allocator) ![:0]const u8 {
    var len: usize = undefined;
    try err(shim.napi_get_value_string_utf8(_env(e), value, null, 0, &len));
    const res = try allocator.allocSentinel(u8, len, 0);
    try err(shim.napi_get_value_string_utf8(_env(e), value, res.ptr, len + 1, null));
    return res;
}

pub fn _getValueU32(e: anytype, value: v) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_value_uint32(_env(e), value, &result));
    return result;
}

pub fn _getVersion(e: anytype) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_get_version(_env(e), &result));
    return result;
}

pub fn _hasElement(e: anytype, object: v, index: usize) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_element(_env(e), object, @truncate(index), &result));
    return result;
}

pub fn _hasNamedProperty(e: anytype, object: v, utf8name: [:0]const u8) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_named_property(_env(e), object, utf8name.ptr, &result));
    return result;
}

pub fn _hasOwnProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_own_property(_env(e), object, key, &result));
    return result;
}

pub fn _hasProperty(e: anytype, object: v, key: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_has_property(_env(e), object, key, &result));
    return result;
}

pub fn _instanceOf(e: anytype, object: v, constructor: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_instanceof(_env(e), object, constructor, &result));
    return result;
}

pub fn _isArray(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_array(_env(e), value, &result));
    return result;
}

pub fn _isArraybuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_arraybuffer(_env(e), value, &result));
    return result;
}

pub fn _isBuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_buffer(_env(e), value, &result));
    return result;
}

pub fn _isDataview(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_dataview(_env(e), value, &result));
    return result;
}

pub fn _isDate(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_date(_env(e), value, &result));
    return result;
}

pub fn _isDetachedArraybuffer(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_detached_arraybuffer(_env(e), value, &result));
    return result;
}

pub fn _isError(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_error(_env(e), value, &result));
    return result;
}

pub fn _isExceptionPending(e: anytype) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_exception_pending(_env(e), &result));
    return result;
}

pub fn _isPromise(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_promise(_env(e), value, &result));
    return result;
}

pub fn _isTypedarray(e: anytype, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_is_typedarray(_env(e), value, &result));
    return result;
}

pub fn _newInstance(e: anytype, constructor: v, args: []const v) !v {
    var result: v = undefined;
    try err(shim.napi_new_instance(_env(e), constructor, args.len, args.ptr, &result));
    return result;
}

pub fn _objectFreeze(e: anytype, object: v) !void {
    try err(shim.napi_object_freeze(_env(e), object));
}

pub fn _objectSeal(e: anytype, object: v) !void {
    try err(shim.napi_object_seal(_env(e), object));
}

pub fn _referenceRef(e: anytype, ref: n.napi_ref) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_reference_ref(_env(e), ref, &result));
    return result;
}

pub fn _referenceUnref(e: anytype, ref: n.napi_ref) !u32 {
    var result: u32 = undefined;
    try err(shim.napi_reference_unref(_env(e), ref, &result));
    return result;
}

pub fn _removeWrap(e: anytype, js_object: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_remove_wrap(_env(e), js_object, &result));
    return result;
}

pub fn _runScript(e: anytype, script: v) !v {
    var result: v = undefined;
    try err(shim.napi_run_script(_env(e), script, &result));
    return result;
}

pub fn _setElement(e: anytype, object: v, index: usize, value: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_set_element(_env(e), object, @truncate(index), value, &result));
    return result;
}

pub fn _setNamedProperty(e: anytype, object: v, utf8name: [:0]const u8, value: v) !void {
    try err(shim.napi_set_named_property(_env(e), object, utf8name.ptr, value));
}

pub fn _setProperty(e: anytype, object: v, key: v, value: v) !void {
    try err(shim.napi_set_property(_env(e), object, key, value));
}

pub fn _strictEquals(e: anytype, lhs: v, rhs: v) !bool {
    var result: bool = undefined;
    try err(shim.napi_strict_equals(_env(e), lhs, rhs, &result));
    return result;
}

pub fn _throw(e: anytype, value: v) !void {
    try err(shim.napi_throw(_env(e), value));
}

pub fn _throwError(e: anytype, code: v, msg: v) !void {
    try err(shim.napi_throw_error(_env(e), code, msg));
}

pub fn _throwRangeError(e: anytype, code: v, msg: v) !void {
    try err(shim.napi_throw_range_error(_env(e), code, msg));
}

pub fn _throwTypeError(e: anytype, code: v, msg: v) !void {
    try err(shim.napi_throw_type_error(_env(e), code, msg));
}

pub fn _typeTagObject(e: anytype, value: v, type_tag: n.napi_type_tag) !void {
    try err(shim.napi_type_tag_object(_env(e), value, type_tag));
}

pub fn _typeOf(e: anytype, value: v) !n.napi_valuetype {
    var result: n.napi_valuetype = undefined;
    try err(shim.napi_typeof(_env(e), value, &result));
    return result;
}

pub fn _unwrap(e: anytype, js_object: v) !?*anyopaque {
    var result: ?*anyopaque = undefined;
    try err(shim.napi_unwrap(_env(e), js_object, &result));
    return result;
}

pub fn _wrap(e: anytype, js_object: v, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque) !n.napi_ref {
    var result: n.napi_ref = undefined;
    try err(shim.napi_wrap(_env(e), js_object, native_object, finalize_cb, finalize_hint, &result));
    return result;
}

pub fn _createPropertyKeyLatin1(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_latin1(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _createPropertyKeyUtf16(e: anytype, str: []const u16) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_utf16(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _createPropertyKeyUtf8(e: anytype, str: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_create_property_key_utf8(_env(e), str.ptr, str.len, &result));
    return result;
}

pub fn _symbolFor(e: anytype, description: []const u8) !v {
    var result: v = undefined;
    try err(shim.node_api_symbol_for(_env(e), description.ptr, description.len, &result));
    return result;
}
