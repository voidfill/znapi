const n = @import("napi_types.zig");

/// https://nodejs.org/api/n-api.html#napi_acquire_threadsafe_function
pub extern fn napi_acquire_threadsafe_function(func: n.threadsafe_function) n.status;
/// https://nodejs.org/api/n-api.html#napi_add_async_cleanup_hook
pub extern fn napi_add_async_cleanup_hook(env: n.basic_env, hook: n.async_cleanup_hook, arg: ?*anyopaque, remove_handle: [*c]n.async_cleanup_hook_handle) n.status;
/// https://nodejs.org/api/n-api.html#napi_add_env_cleanup_hook
pub extern fn napi_add_env_cleanup_hook(env: n.basic_env, fun: n.cleanup_hook, arg: ?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_add_finalizer
pub extern fn napi_add_finalizer(env: n.env, js_object: n.value, finalize_data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.ref) n.status;
/// https://nodejs.org/api/n-api.html#napi_adjust_external_memory
pub extern fn napi_adjust_external_memory(env: n.basic_env, change_in_bytes: i64, adjusted_value: [*c]i64) n.status;
/// https://nodejs.org/api/n-api.html#napi_async_destroy
pub extern fn napi_async_destroy(env: n.env, async_context: n.async_context) n.status;
/// https://nodejs.org/api/n-api.html#napi_async_init
pub extern fn napi_async_init(env: n.env, async_resource: n.value, async_resource_name: n.value, result: [*c]n.async_context) n.status;
/// https://nodejs.org/api/n-api.html#napi_call_function
pub extern fn napi_call_function(env: n.env, recv: n.value, func: n.value, argc: usize, argv: [*c]const n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_call_threadsafe_function
pub extern fn napi_call_threadsafe_function(func: n.threadsafe_function, data: ?*anyopaque, is_blocking: n.threadsafe_function_call_mode) n.status;
/// https://nodejs.org/api/n-api.html#napi_cancel_async_work
pub extern fn napi_cancel_async_work(env: n.basic_env, work: n.async_work) n.status;
/// https://nodejs.org/api/n-api.html#napi_check_object_type_tag
pub extern fn napi_check_object_type_tag(env: n.env, value: n.value, type_tag: [*c]const n.type_tag, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_close_callback_scope
pub extern fn napi_close_callback_scope(env: n.env, scope: n.callback_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_close_escapable_handle_scope
pub extern fn napi_close_escapable_handle_scope(env: n.env, scope: n.escapable_handle_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_close_handle_scope
pub extern fn napi_close_handle_scope(env: n.env, scope: n.handle_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_bool
pub extern fn napi_coerce_to_bool(env: n.env, value: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_number
pub extern fn napi_coerce_to_number(env: n.env, value: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_object
pub extern fn napi_coerce_to_object(env: n.env, value: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_coerce_to_string
pub extern fn napi_coerce_to_string(env: n.env, value: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_array
pub extern fn napi_create_array(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_array_with_length
pub extern fn napi_create_array_with_length(env: n.env, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_arraybuffer
pub extern fn napi_create_arraybuffer(env: n.env, byte_length: usize, data: [*c]?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_async_work
pub extern fn napi_create_async_work(env: n.env, async_resource: n.value, async_resource_name: n.value, execute: n.async_execute_callback, complete: n.async_complete_callback, data: ?*anyopaque, result: [*c]n.async_work) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_int64
pub extern fn napi_create_bigint_int64(env: n.env, value: i64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_uint64
pub extern fn napi_create_bigint_uint64(env: n.env, value: u64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_bigint_words
pub extern fn napi_create_bigint_words(env: n.env, sign_bit: c_int, word_count: usize, words: [*c]const u64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_buffer
pub extern fn napi_create_buffer(env: n.env, length: usize, data: [*c]?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_buffer_copy
pub extern fn napi_create_buffer_copy(env: n.env, length: usize, data: ?*const anyopaque, result_data: [*c]?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_dataview
pub extern fn napi_create_dataview(env: n.env, length: usize, arraybuffer: n.value, byte_offset: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_date
pub extern fn napi_create_date(env: n.env, time: f64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_double
pub extern fn napi_create_double(env: n.env, value: f64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_error
pub extern fn napi_create_error(env: n.env, code: n.value, msg: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_external
pub extern fn napi_create_external(env: n.env, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_external_arraybuffer
pub extern fn napi_create_external_arraybuffer(env: n.env, external_data: ?*anyopaque, byte_length: usize, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_external_buffer
pub extern fn napi_create_external_buffer(env: n.env, length: usize, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_function
pub extern fn napi_create_function(env: n.env, utf8name: [*c]const u8, length: usize, cb: n.callback, data: ?*anyopaque, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_int32
pub extern fn napi_create_int32(env: n.env, value: i32, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_int64
pub extern fn napi_create_int64(env: n.env, value: i64, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_object
pub extern fn napi_create_object(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_promise
pub extern fn napi_create_promise(env: n.env, deferred: [*c]n.deferred, promise: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_range_error
pub extern fn napi_create_range_error(env: n.env, code: n.value, msg: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_reference
pub extern fn napi_create_reference(env: n.env, value: n.value, initial_refcount: u32, result: [*c]n.ref) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_string_latin1
pub extern fn napi_create_string_latin1(env: n.env, str: [*c]const u8, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_string_utf16
pub extern fn napi_create_string_utf16(env: n.env, str: [*c]const u16, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_string_utf8
pub extern fn napi_create_string_utf8(env: n.env, str: [*c]const u8, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_symbol
pub extern fn napi_create_symbol(env: n.env, description: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_threadsafe_function
pub extern fn napi_create_threadsafe_function(env: n.env, func: n.value, async_resource: n.value, async_resource_name: n.value, max_queue_size: usize, initial_thread_count: usize, thread_finalize_data: ?*anyopaque, thread_finalize_cb: n.finalize, context: ?*anyopaque, call_js_cb: n.threadsafe_function_call_js, result: [*c]n.threadsafe_function) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_type_error
pub extern fn napi_create_type_error(env: n.env, code: n.value, msg: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_typedarray
pub extern fn napi_create_typedarray(env: n.env, @"type": n.typedarray_type, length: usize, arraybuffer: n.value, byte_offset: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_create_uint32
pub extern fn napi_create_uint32(env: n.env, value: u32, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_define_class
pub extern fn napi_define_class(env: n.env, utf8name: [*c]const u8, length: usize, constructor: n.callback, data: ?*anyopaque, property_count: usize, properties: [*c]const n.property_descriptor, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_define_properties
pub extern fn napi_define_properties(env: n.env, object: n.value, property_count: usize, properties: [*c]const n.property_descriptor) n.status;
/// https://nodejs.org/api/n-api.html#napi_delete_async_work
pub extern fn napi_delete_async_work(env: n.env, work: n.async_work) n.status;
/// https://nodejs.org/api/n-api.html#napi_delete_element
pub extern fn napi_delete_element(env: n.env, object: n.value, index: u32, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_delete_property
pub extern fn napi_delete_property(env: n.env, object: n.value, key: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_delete_reference
pub extern fn napi_delete_reference(env: n.env, ref: n.ref) n.status;
/// https://nodejs.org/api/n-api.html#napi_detach_arraybuffer
pub extern fn napi_detach_arraybuffer(env: n.env, arraybuffer: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_escape_handle
pub extern fn napi_escape_handle(env: n.env, scope: n.escapable_handle_scope, escapee: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_fatal_error
pub extern fn napi_fatal_error(location: [*c]const u8, location_len: usize, message: [*c]const u8, message_len: usize) noreturn;
/// https://nodejs.org/api/n-api.html#napi_fatal_exception
pub extern fn napi_fatal_exception(env: n.env, err: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_all_property_names
pub extern fn napi_get_all_property_names(env: n.env, object: n.value, key_mode: n.key_collection_mode, key_filter: n.key_filter, key_conversion: n.key_conversion, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_and_clear_last_exception
pub extern fn napi_get_and_clear_last_exception(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_array_length
pub extern fn napi_get_array_length(env: n.env, value: n.value, result: [*c]u32) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_arraybuffer_info
pub extern fn napi_get_arraybuffer_info(env: n.env, arraybuffer: n.value, data: [*c]?*anyopaque, byte_length: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_boolean
pub extern fn napi_get_boolean(env: n.env, value: bool, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_buffer_info
pub extern fn napi_get_buffer_info(env: n.env, value: n.value, data: [*c]?*anyopaque, length: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_cb_info
pub extern fn napi_get_cb_info(env: n.env, cbinfo: n.callback_info, argc: [*c]usize, argv: [*c]n.value, this_arg: [*c]n.value, data: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_dataview_info
pub extern fn napi_get_dataview_info(env: n.env, dataview: n.value, bytelength: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.value, byte_offset: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_date_value
pub extern fn napi_get_date_value(env: n.env, value: n.value, result: [*c]f64) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_element
pub extern fn napi_get_element(env: n.env, object: n.value, index: u32, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_global
pub extern fn napi_get_global(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_instance_data
pub extern fn napi_get_instance_data(env: n.basic_env, data: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_last_error_info
pub extern fn napi_get_last_error_info(env: n.basic_env, result: [*c][*c]const n.extended_error_info) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_named_property
pub extern fn napi_get_named_property(env: n.env, object: n.value, utf8name: [*c]const u8, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_new_target
pub extern fn napi_get_new_target(env: n.env, cbinfo: n.callback_info, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_node_version
pub extern fn napi_get_node_version(env: n.basic_env, version: [*c][*c]const n.node_version) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_null
pub extern fn napi_get_null(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_property
pub extern fn napi_get_property(env: n.env, object: n.value, key: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_property_names
pub extern fn napi_get_property_names(env: n.env, object: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_prototype
pub extern fn napi_get_prototype(env: n.env, object: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_reference_value
pub extern fn napi_get_reference_value(env: n.env, ref: n.ref, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_threadsafe_function_context
pub extern fn napi_get_threadsafe_function_context(func: n.threadsafe_function, result: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_typedarray_info
pub extern fn napi_get_typedarray_info(env: n.env, typedarray: n.value, @"type": [*c]n.typedarray_type, length: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.value, byte_offset: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_undefined
pub extern fn napi_get_undefined(env: n.env, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_uv_event_loop
pub extern fn napi_get_uv_event_loop(env: n.basic_env, loop: [*c]?*n.struct_uv_loop_s) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_int64
pub extern fn napi_get_value_bigint_int64(env: n.env, value: n.value, result: [*c]i64, lossless: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_uint64
pub extern fn napi_get_value_bigint_uint64(env: n.env, value: n.value, result: [*c]u64, lossless: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bigint_words
pub extern fn napi_get_value_bigint_words(env: n.env, value: n.value, sign_bit: [*c]c_int, word_count: [*c]usize, words: [*c]u64) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_bool
pub extern fn napi_get_value_bool(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_double
pub extern fn napi_get_value_double(env: n.env, value: n.value, result: [*c]f64) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_external
pub extern fn napi_get_value_external(env: n.env, value: n.value, result: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_int32
pub extern fn napi_get_value_int32(env: n.env, value: n.value, result: [*c]i32) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_int64
pub extern fn napi_get_value_int64(env: n.env, value: n.value, result: [*c]i64) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_latin1
pub extern fn napi_get_value_string_latin1(env: n.env, value: n.value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_utf16
pub extern fn napi_get_value_string_utf16(env: n.env, value: n.value, buf: [*c]u16, bufsize: usize, result: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_string_utf8
pub extern fn napi_get_value_string_utf8(env: n.env, value: n.value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_value_uint32
pub extern fn napi_get_value_uint32(env: n.env, value: n.value, result: [*c]u32) n.status;
/// https://nodejs.org/api/n-api.html#napi_get_version
pub extern fn napi_get_version(env: n.basic_env, result: [*c]u32) n.status;
/// https://nodejs.org/api/n-api.html#napi_has_element
pub extern fn napi_has_element(env: n.env, object: n.value, index: u32, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_has_named_property
pub extern fn napi_has_named_property(env: n.env, object: n.value, utf8name: [*c]const u8, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_has_own_property
pub extern fn napi_has_own_property(env: n.env, object: n.value, key: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_has_property
pub extern fn napi_has_property(env: n.env, object: n.value, key: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_instanceof
pub extern fn napi_instanceof(env: n.env, object: n.value, constructor: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_array
pub extern fn napi_is_array(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_arraybuffer
pub extern fn napi_is_arraybuffer(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_buffer
pub extern fn napi_is_buffer(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_dataview
pub extern fn napi_is_dataview(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_date
pub extern fn napi_is_date(env: n.env, value: n.value, is_date: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_detached_arraybuffer
pub extern fn napi_is_detached_arraybuffer(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_error
pub extern fn napi_is_error(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_exception_pending
pub extern fn napi_is_exception_pending(env: n.env, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_promise
pub extern fn napi_is_promise(env: n.env, value: n.value, is_promise: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_is_typedarray
pub extern fn napi_is_typedarray(env: n.env, value: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_make_callback
pub extern fn napi_make_callback(env: n.env, async_context: n.async_context, recv: n.value, func: n.value, argc: usize, argv: [*c]const n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_module_register
pub extern fn napi_module_register(mod: [*c]n.module) void;
/// https://nodejs.org/api/n-api.html#napi_new_instance
pub extern fn napi_new_instance(env: n.env, constructor: n.value, argc: usize, argv: [*c]const n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_object_freeze
pub extern fn napi_object_freeze(env: n.env, object: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_object_seal
pub extern fn napi_object_seal(env: n.env, object: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_open_callback_scope
pub extern fn napi_open_callback_scope(env: n.env, resource_object: n.value, context: n.async_context, result: [*c]n.callback_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_open_escapable_handle_scope
pub extern fn napi_open_escapable_handle_scope(env: n.env, result: [*c]n.escapable_handle_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_open_handle_scope
pub extern fn napi_open_handle_scope(env: n.env, result: [*c]n.handle_scope) n.status;
/// https://nodejs.org/api/n-api.html#napi_queue_async_work
pub extern fn napi_queue_async_work(env: n.basic_env, work: n.async_work) n.status;
/// https://nodejs.org/api/n-api.html#napi_ref_threadsafe_function
pub extern fn napi_ref_threadsafe_function(env: n.basic_env, func: n.threadsafe_function) n.status;
/// https://nodejs.org/api/n-api.html#napi_reference_ref
pub extern fn napi_reference_ref(env: n.env, ref: n.ref, result: [*c]u32) n.status;
/// https://nodejs.org/api/n-api.html#napi_reference_unref
pub extern fn napi_reference_unref(env: n.env, ref: n.ref, result: [*c]u32) n.status;
/// https://nodejs.org/api/n-api.html#napi_reject_deferred
pub extern fn napi_reject_deferred(env: n.env, deferred: n.deferred, rejection: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_release_threadsafe_function
pub extern fn napi_release_threadsafe_function(func: n.threadsafe_function, mode: n.threadsafe_function_release_mode) n.status;
/// https://nodejs.org/api/n-api.html#napi_remove_async_cleanup_hook
pub extern fn napi_remove_async_cleanup_hook(remove_handle: n.async_cleanup_hook_handle) n.status;
/// https://nodejs.org/api/n-api.html#napi_remove_env_cleanup_hook
pub extern fn napi_remove_env_cleanup_hook(env: n.basic_env, fun: n.cleanup_hook, arg: ?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_remove_wrap
pub extern fn napi_remove_wrap(env: n.env, js_object: n.value, result: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_resolve_deferred
pub extern fn napi_resolve_deferred(env: n.env, deferred: n.deferred, resolution: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_run_script
pub extern fn napi_run_script(env: n.env, script: n.value, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_set_element
pub extern fn napi_set_element(env: n.env, object: n.value, index: u32, value: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_set_instance_data
pub extern fn napi_set_instance_data(env: n.basic_env, data: ?*anyopaque, finalize_cb: n.finalize, finalize_hint: ?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_set_named_property
pub extern fn napi_set_named_property(env: n.env, object: n.value, utf8name: [*c]const u8, value: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_set_property
pub extern fn napi_set_property(env: n.env, object: n.value, key: n.value, value: n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_strict_equals
pub extern fn napi_strict_equals(env: n.env, lhs: n.value, rhs: n.value, result: [*c]bool) n.status;
/// https://nodejs.org/api/n-api.html#napi_throw
pub extern fn napi_throw(env: n.env, @"error": n.value) n.status;
/// https://nodejs.org/api/n-api.html#napi_throw_error
pub extern fn napi_throw_error(env: n.env, code: [*c]const u8, msg: [*c]const u8) n.status;
/// https://nodejs.org/api/n-api.html#napi_throw_range_error
pub extern fn napi_throw_range_error(env: n.env, code: [*c]const u8, msg: [*c]const u8) n.status;
/// https://nodejs.org/api/n-api.html#napi_throw_type_error
pub extern fn napi_throw_type_error(env: n.env, code: [*c]const u8, msg: [*c]const u8) n.status;
/// https://nodejs.org/api/n-api.html#napi_type_tag_object
pub extern fn napi_type_tag_object(env: n.env, value: n.value, type_tag: [*c]const n.type_tag) n.status;
/// https://nodejs.org/api/n-api.html#napi_typeof
pub extern fn napi_typeof(env: n.env, value: n.value, result: [*c]n.valuetype) n.status;
/// https://nodejs.org/api/n-api.html#napi_unref_threadsafe_function
pub extern fn napi_unref_threadsafe_function(env: n.basic_env, func: n.threadsafe_function) n.status;
/// https://nodejs.org/api/n-api.html#napi_unwrap
pub extern fn napi_unwrap(env: n.env, js_object: n.value, result: [*c]?*anyopaque) n.status;
/// https://nodejs.org/api/n-api.html#napi_wrap
pub extern fn napi_wrap(env: n.env, js_object: n.value, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.ref) n.status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_latin1
pub extern fn node_api_create_property_key_latin1(env: n.env, str: [*c]const u8, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_utf16
pub extern fn node_api_create_property_key_utf16(env: n.env, str: [*c]const u8, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#node_api_create_property_key_utf8
pub extern fn node_api_create_property_key_utf8(env: n.env, str: [*c]const u8, length: usize, result: [*c]n.value) n.status;
/// https://nodejs.org/api/n-api.html#node_api_symbol_for
pub extern fn node_api_symbol_for(env: n.env, description: [*c]const u8, length: usize, result: [*c]n.value) n.status;
