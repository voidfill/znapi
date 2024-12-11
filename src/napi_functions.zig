const n = @import("napi_types.zig");

/// https://nodejs.org/api/n-api.html#napi_acquire_threadsafe_function
pub extern fn napi_acquire_threadsafe_function(func: n.napi_threadsafe_function) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_add_async_cleanup_hook
pub extern fn napi_add_async_cleanup_hook(env: n.node_api_basic_env, hook: n.napi_async_cleanup_hook, arg: ?*anyopaque, remove_handle: [*c]n.napi_async_cleanup_hook_handle) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_add_env_cleanup_hook
pub extern fn napi_add_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_add_finalizer
pub extern fn napi_add_finalizer(env: n.napi_env, js_object: n.napi_value, finalize_data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_adjust_external_memory
pub extern fn napi_adjust_external_memory(env: n.node_api_basic_env, change_in_bytes: i64, adjusted_value: [*c]i64) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_async_destroy
pub extern fn napi_async_destroy(env: n.napi_env, async_context: n.napi_async_context) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_async_init
pub extern fn napi_async_init(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, result: [*c]n.napi_async_context) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_call_function
pub extern fn napi_call_function(env: n.napi_env, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_call_threadsafe_function
pub extern fn napi_call_threadsafe_function(func: n.napi_threadsafe_function, data: ?*anyopaque, is_blocking: n.napi_threadsafe_function_call_mode) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_cancel_async_work
pub extern fn napi_cancel_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_check_object_type_tag
pub extern fn napi_check_object_type_tag(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_close_callback_scope
pub extern fn napi_close_callback_scope(env: n.napi_env, scope: n.napi_callback_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_close_escapable_handle_scope
pub extern fn napi_close_escapable_handle_scope(env: n.napi_env, scope: n.napi_escapable_handle_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_close_handle_scope
pub extern fn napi_close_handle_scope(env: n.napi_env, scope: n.napi_handle_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_bool
pub extern fn napi_coerce_to_bool(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_number
pub extern fn napi_coerce_to_number(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_object
pub extern fn napi_coerce_to_object(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_string
pub extern fn napi_coerce_to_string(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_array
pub extern fn napi_create_array(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_array_with_length
pub extern fn napi_create_array_with_length(env: n.napi_env, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_arraybuffer
pub extern fn napi_create_arraybuffer(env: n.napi_env, byte_length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_async_work
pub extern fn napi_create_async_work(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, execute: n.napi_async_execute_callback, complete: n.napi_async_complete_callback, data: ?*anyopaque, result: [*c]n.napi_async_work) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_int64
pub extern fn napi_create_bigint_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_uint64
pub extern fn napi_create_bigint_uint64(env: n.napi_env, value: u64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_words
pub extern fn napi_create_bigint_words(env: n.napi_env, sign_bit: c_int, word_count: usize, words: [*c]const u64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_buffer
pub extern fn napi_create_buffer(env: n.napi_env, length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_buffer_copy
pub extern fn napi_create_buffer_copy(env: n.napi_env, length: usize, data: ?*const anyopaque, result_data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_dataview
pub extern fn napi_create_dataview(env: n.napi_env, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_date
pub extern fn napi_create_date(env: n.napi_env, time: f64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_double
pub extern fn napi_create_double(env: n.napi_env, value: f64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_error
pub extern fn napi_create_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_external
pub extern fn napi_create_external(env: n.napi_env, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_external_arraybuffer
pub extern fn napi_create_external_arraybuffer(env: n.napi_env, external_data: ?*anyopaque, byte_length: usize, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_external_buffer
pub extern fn napi_create_external_buffer(env: n.napi_env, length: usize, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_function
pub extern fn napi_create_function(env: n.napi_env, utf8name: [*c]const u8, length: usize, cb: n.napi_callback, data: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_int32
pub extern fn napi_create_int32(env: n.napi_env, value: i32, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_int64
pub extern fn napi_create_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_object
pub extern fn napi_create_object(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_promise
pub extern fn napi_create_promise(env: n.napi_env, deferred: [*c]n.napi_deferred, promise: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_range_error
pub extern fn napi_create_range_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_reference
pub extern fn napi_create_reference(env: n.napi_env, value: n.napi_value, initial_refcount: u32, result: [*c]n.napi_ref) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_string_latin1
pub extern fn napi_create_string_latin1(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_string_utf16
pub extern fn napi_create_string_utf16(env: n.napi_env, str: [*c]const u16, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_string_utf8
pub extern fn napi_create_string_utf8(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_symbol
pub extern fn napi_create_symbol(env: n.napi_env, description: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_threadsafe_function
pub extern fn napi_create_threadsafe_function(env: n.napi_env, func: n.napi_value, async_resource: n.napi_value, async_resource_name: n.napi_value, max_queue_size: usize, initial_thread_count: usize, thread_finalize_data: ?*anyopaque, thread_finalize_cb: n.napi_finalize, context: ?*anyopaque, call_js_cb: n.napi_threadsafe_function_call_js, result: [*c]n.napi_threadsafe_function) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_type_error
pub extern fn napi_create_type_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_typedarray
pub extern fn napi_create_typedarray(env: n.napi_env, @"type": n.napi_typedarray_type, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_create_uint32
pub extern fn napi_create_uint32(env: n.napi_env, value: u32, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_define_class
pub extern fn napi_define_class(env: n.napi_env, utf8name: [*c]const u8, length: usize, constructor: n.napi_callback, data: ?*anyopaque, property_count: usize, properties: [*c]const n.napi_property_descriptor, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_define_properties
pub extern fn napi_define_properties(env: n.napi_env, object: n.napi_value, property_count: usize, properties: [*c]const n.napi_property_descriptor) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_delete_async_work
pub extern fn napi_delete_async_work(env: n.napi_env, work: n.napi_async_work) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_delete_element
pub extern fn napi_delete_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_delete_property
pub extern fn napi_delete_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_delete_reference
pub extern fn napi_delete_reference(env: n.napi_env, ref: n.napi_ref) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_detach_arraybuffer
pub extern fn napi_detach_arraybuffer(env: n.napi_env, arraybuffer: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_escape_handle
pub extern fn napi_escape_handle(env: n.napi_env, scope: n.napi_escapable_handle_scope, escapee: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_fatal_error
pub extern fn napi_fatal_error(location: [*c]const u8, location_len: usize, message: [*c]const u8, message_len: usize) noreturn;
/// https://nodejs.org/api/n-api.html#napi_fatal_exception
pub extern fn napi_fatal_exception(env: n.napi_env, err: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_all_property_names
pub extern fn napi_get_all_property_names(env: n.napi_env, object: n.napi_value, key_mode: n.napi_key_collection_mode, key_filter: n.napi_key_filter, key_conversion: n.napi_key_conversion, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_and_clear_last_exception
pub extern fn napi_get_and_clear_last_exception(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_array_length
pub extern fn napi_get_array_length(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_arraybuffer_info
pub extern fn napi_get_arraybuffer_info(env: n.napi_env, arraybuffer: n.napi_value, data: [*c]?*anyopaque, byte_length: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_boolean
pub extern fn napi_get_boolean(env: n.napi_env, value: bool, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_buffer_info
pub extern fn napi_get_buffer_info(env: n.napi_env, value: n.napi_value, data: [*c]?*anyopaque, length: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_cb_info
pub extern fn napi_get_cb_info(env: n.napi_env, cbinfo: n.napi_callback_info, argc: [*c]usize, argv: [*c]n.napi_value, this_arg: [*c]n.napi_value, data: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_dataview_info
pub extern fn napi_get_dataview_info(env: n.napi_env, dataview: n.napi_value, bytelength: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_date_value
pub extern fn napi_get_date_value(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_element
pub extern fn napi_get_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_global
pub extern fn napi_get_global(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_instance_data
pub extern fn napi_get_instance_data(env: n.node_api_basic_env, data: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_last_error_info
pub extern fn napi_get_last_error_info(env: n.node_api_basic_env, result: [*c][*c]const n.napi_extended_error_info) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_named_property
pub extern fn napi_get_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_new_target
pub extern fn napi_get_new_target(env: n.napi_env, cbinfo: n.napi_callback_info, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_node_version
pub extern fn napi_get_node_version(env: n.node_api_basic_env, version: [*c][*c]const n.napi_node_version) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_null
pub extern fn napi_get_null(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_property
pub extern fn napi_get_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_property_names
pub extern fn napi_get_property_names(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_prototype
pub extern fn napi_get_prototype(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_reference_value
pub extern fn napi_get_reference_value(env: n.napi_env, ref: n.napi_ref, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_threadsafe_function_context
pub extern fn napi_get_threadsafe_function_context(func: n.napi_threadsafe_function, result: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_typedarray_info
pub extern fn napi_get_typedarray_info(env: n.napi_env, typedarray: n.napi_value, @"type": [*c]n.napi_typedarray_type, length: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_undefined
pub extern fn napi_get_undefined(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_uv_event_loop
pub extern fn napi_get_uv_event_loop(env: n.node_api_basic_env, loop: [*c]?*n.struct_uv_loop_s) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_int64
pub extern fn napi_get_value_bigint_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64, lossless: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_uint64
pub extern fn napi_get_value_bigint_uint64(env: n.napi_env, value: n.napi_value, result: [*c]u64, lossless: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_words
pub extern fn napi_get_value_bigint_words(env: n.napi_env, value: n.napi_value, sign_bit: [*c]c_int, word_count: [*c]usize, words: [*c]u64) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bool
pub extern fn napi_get_value_bool(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_double
pub extern fn napi_get_value_double(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_external
pub extern fn napi_get_value_external(env: n.napi_env, value: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_int32
pub extern fn napi_get_value_int32(env: n.napi_env, value: n.napi_value, result: [*c]i32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_int64
pub extern fn napi_get_value_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_latin1
pub extern fn napi_get_value_string_latin1(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_utf16
pub extern fn napi_get_value_string_utf16(env: n.napi_env, value: n.napi_value, buf: [*c]u16, bufsize: usize, result: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_utf8
pub extern fn napi_get_value_string_utf8(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_value_uint32
pub extern fn napi_get_value_uint32(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_get_version
pub extern fn napi_get_version(env: n.node_api_basic_env, result: [*c]u32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_has_element
pub extern fn napi_has_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_has_named_property
pub extern fn napi_has_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_has_own_property
pub extern fn napi_has_own_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_has_property
pub extern fn napi_has_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_instanceof
pub extern fn napi_instanceof(env: n.napi_env, object: n.napi_value, constructor: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_array
pub extern fn napi_is_array(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_arraybuffer
pub extern fn napi_is_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_buffer
pub extern fn napi_is_buffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_dataview
pub extern fn napi_is_dataview(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_date
pub extern fn napi_is_date(env: n.napi_env, value: n.napi_value, is_date: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_detached_arraybuffer
pub extern fn napi_is_detached_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_error
pub extern fn napi_is_error(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_exception_pending
pub extern fn napi_is_exception_pending(env: n.napi_env, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_promise
pub extern fn napi_is_promise(env: n.napi_env, value: n.napi_value, is_promise: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_is_typedarray
pub extern fn napi_is_typedarray(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_make_callback
pub extern fn napi_make_callback(env: n.napi_env, async_context: n.napi_async_context, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_module_register
pub extern fn napi_module_register(mod: [*c]n.napi_module) void;
/// https://nodejs.org/api/n-api.html#napi_new_instance
pub extern fn napi_new_instance(env: n.napi_env, constructor: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_object_freeze
pub extern fn napi_object_freeze(env: n.napi_env, object: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_object_seal
pub extern fn napi_object_seal(env: n.napi_env, object: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_open_callback_scope
pub extern fn napi_open_callback_scope(env: n.napi_env, resource_object: n.napi_value, context: n.napi_async_context, result: [*c]n.napi_callback_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_open_escapable_handle_scope
pub extern fn napi_open_escapable_handle_scope(env: n.napi_env, result: [*c]n.napi_escapable_handle_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_open_handle_scope
pub extern fn napi_open_handle_scope(env: n.napi_env, result: [*c]n.napi_handle_scope) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_queue_async_work
pub extern fn napi_queue_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_ref_threadsafe_function
pub extern fn napi_ref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_reference_ref
pub extern fn napi_reference_ref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_reference_unref
pub extern fn napi_reference_unref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_reject_deferred
pub extern fn napi_reject_deferred(env: n.napi_env, deferred: n.napi_deferred, rejection: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_release_threadsafe_function
pub extern fn napi_release_threadsafe_function(func: n.napi_threadsafe_function, mode: n.napi_threadsafe_function_release_mode) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_remove_async_cleanup_hook
pub extern fn napi_remove_async_cleanup_hook(remove_handle: n.napi_async_cleanup_hook_handle) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_remove_env_cleanup_hook
pub extern fn napi_remove_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_remove_wrap
pub extern fn napi_remove_wrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_resolve_deferred
pub extern fn napi_resolve_deferred(env: n.napi_env, deferred: n.napi_deferred, resolution: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_run_script
pub extern fn napi_run_script(env: n.napi_env, script: n.napi_value, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_set_element
pub extern fn napi_set_element(env: n.napi_env, object: n.napi_value, index: u32, value: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_set_instance_data
pub extern fn napi_set_instance_data(env: n.node_api_basic_env, data: ?*anyopaque, finalize_cb: n.napi_finalize, finalize_hint: ?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_set_named_property
pub extern fn napi_set_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, value: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_set_property
pub extern fn napi_set_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, value: n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_strict_equals
pub extern fn napi_strict_equals(env: n.napi_env, lhs: n.napi_value, rhs: n.napi_value, result: [*c]bool) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_throw
pub extern fn napi_throw(env: n.napi_env, @"error": n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_throw_error
pub extern fn napi_throw_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_throw_range_error
pub extern fn napi_throw_range_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_throw_type_error
pub extern fn napi_throw_type_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_type_tag_object
pub extern fn napi_type_tag_object(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_typeof
pub extern fn napi_typeof(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_valuetype) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_unref_threadsafe_function
pub extern fn napi_unref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_unwrap
pub extern fn napi_unwrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
/// https://nodejs.org/api/n-api.html#napi_wrap
pub extern fn napi_wrap(env: n.napi_env, js_object: n.napi_value, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_latin1
pub extern fn node_api_create_property_key_latin1(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_utf16
pub extern fn node_api_create_property_key_utf16(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_utf8
pub extern fn node_api_create_property_key_utf8(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
/// https://nodejs.org/api/n-api.html#node_api_symbol_for
pub extern fn node_api_symbol_for(env: n.napi_env, description: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
