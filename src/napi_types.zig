const zeroes = @import("std").mem.zeroes;

pub const env = ?*opaque {};
pub const basic_env = ?*opaque {};
pub const value = ?*opaque {};
pub const ref = ?*opaque {};
pub const handle_scope = ?*opaque {};
pub const escapable_handle_scope = ?*opaque {};
pub const callback_info = ?*opaque {};
pub const deferred = ?*opaque {};
pub const callback_scope = ?*opaque {};
pub const async_context = ?*opaque {};
pub const async_work = ?*opaque {};
pub const threadsafe_function = ?*opaque {};
pub const async_cleanup_hook_handle = ?*opaque {};
pub const struct_uv_loop_s = opaque {};

pub const callback = ?*const fn (env, callback_info) callconv(.C) value;
pub const finalize = ?*const fn (env, ?*anyopaque, ?*anyopaque) callconv(.C) void;
pub const cleanup_hook = ?*const fn (?*anyopaque) callconv(.C) void;
pub const async_execute_callback = ?*const fn (env, ?*anyopaque) callconv(.C) void;
pub const async_complete_callback = ?*const fn (env, status, ?*anyopaque) callconv(.C) void;
pub const threadsafe_function_call_js = ?*const fn (env, value, ?*anyopaque, ?*anyopaque) callconv(.C) void;
pub const async_cleanup_hook = ?*const fn (async_cleanup_hook_handle, ?*anyopaque) callconv(.C) void;
pub const addon_register_func = ?*const fn (env, value) callconv(.C) value;
pub const node_api_addon_get_api_version_func = ?*const fn () callconv(.C) i32;
pub const node_api_nogc_finalize = finalize;
pub const node_api_basic_finalize = node_api_nogc_finalize;

pub const status = enum(c_uint) {
    ok = 0,
    invalid_arg = 1,
    object_expected = 2,
    string_expected = 3,
    name_expected = 4,
    function_expected = 5,
    number_expected = 6,
    boolean_expected = 7,
    array_expected = 8,
    generic_failure = 9,
    pending_exception = 10,
    cancelled = 11,
    escape_called_twice = 12,
    handle_scope_mismatch = 13,
    callback_scope_mismatch = 14,
    queue_full = 15,
    closing = 16,
    bigint_expected = 17,
    date_expected = 18,
    arraybuffer_expected = 19,
    detachable_arraybuffer_expected = 20,
    would_deadlock = 21,
    no_external_buffers_allowed = 22,
    cannot_run_js = 23,
};

pub const property_attributes = enum(c_uint) {
    default = 0,
    writable = 1,
    enumerable = 2,
    configurable = 4,
    static = 1024,
    default_method = 5,
    default_jsproperty = 7,
    _,
};

pub const valuetype = enum(c_uint) {
    undefined = 0,
    null = 1,
    boolean = 2,
    number = 3,
    string = 4,
    symbol = 5,
    object = 6,
    function = 7,
    external = 8,
    bigint = 9,
};

pub const typedarray_type = enum(c_uint) {
    int8_array = 0,
    uint8_array = 1,
    uint8_clamped_array = 2,
    int16_array = 3,
    uint16_array = 4,
    int32_array = 5,
    uint32_array = 6,
    float32_array = 7,
    float64_array = 8,
    bigint64_array = 9,
    biguint64_array = 10,
};

pub const key_collection_mode = enum(c_uint) {
    include_prototypes = 0,
    own_only = 1,
};

pub const key_filter = enum(c_uint) {
    all_properties = 0,
    only_writable = 1,
    only_enumerable = 2,
    only_configurable = 4,
    skip_strings = 8,
    skip_symbols = 16,
    _,
};

pub const key_conversion = enum(c_uint) {
    keep_numbers = 0,
    numbers_to_strings = 1,
};

pub const property_descriptor = extern struct {
    utf8name: [*c]const u8 = zeroes([*c]const u8),
    name: value = zeroes(value),
    method: callback = zeroes(callback),
    getter: callback = zeroes(callback),
    setter: callback = zeroes(callback),
    value: value = zeroes(value),
    attributes: property_attributes = zeroes(property_attributes),
    data: ?*anyopaque = zeroes(?*anyopaque),
};

pub const extended_error_info = extern struct {
    error_message: [*c]const u8 = zeroes([*c]const u8),
    engine_reserved: ?*anyopaque = zeroes(?*anyopaque),
    engine_error_code: u32 = zeroes(u32),
    error_code: status = zeroes(status),
};

pub const type_tag = extern struct {
    lower: u64 = zeroes(u64),
    upper: u64 = zeroes(u64),
};

pub const threadsafe_function_release_mode = enum(c_uint) {
    release = 0,
    abort = 1,
};

pub const threadsafe_function_call_mode = enum(c_uint) {
    nonblocking = 0,
    blocking = 1,
};

pub const node_version = extern struct {
    major: u32 = zeroes(u32),
    minor: u32 = zeroes(u32),
    patch: u32 = zeroes(u32),
    release: [*c]const u8 = zeroes([*c]const u8),
};

pub const module = extern struct {
    nm_version: c_uint = zeroes(c_uint),
    nm_flags: c_uint = zeroes(c_uint),
    nm_filename: [*c]const u8 = zeroes([*c]const u8),
    nm_register_func: addon_register_func = zeroes(addon_register_func),
    nm_modname: [*c]const u8 = zeroes([*c]const u8),
    nm_priv: ?*anyopaque = zeroes(?*anyopaque),
    reserved: [4]?*anyopaque = zeroes([4]?*anyopaque),
};
