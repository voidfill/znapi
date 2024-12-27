const std = @import("std");
const n = @import("napi_types.zig");
const shim = @import("shim.zig");
const napi_errors = @import("errors.zig");
const wrappers = @import("wrappers.zig");
const to_napi = @import("to_napi.zig");
const from_napi = @import("from_napi.zig");

pub const Ctx = @This();
const Self = Ctx;

// MARK: struct definition

env: n.napi_env,
null: n.napi_value,
undefined: n.napi_value,
global: n.napi_value,
true: n.napi_value,
false: n.napi_value,

/// Creates a new context allocated with the given allocator
pub fn create(env: n.napi_env, allocator: std.mem.Allocator) !*Self {
    const ctx = try allocator.create(Self);
    errdefer allocator.destroy(ctx);

    ctx.* = Self{
        .env = env,
        .null = try Self.getNull(env),
        .undefined = try Self.getUndefined(env),
        .global = try Self.getGlobal(env),
        .true = try Self.getBoolean(env, true),
        .false = try Self.getBoolean(env, false),
    };

    try napi_errors.statusToError(shim.napi_set_instance_data(@ptrCast(env), ctx, null, null));

    return ctx;
}

pub const createInt = to_napi.createInt;
pub const createFloat = to_napi.createFloat;
pub const createArrayFrom = to_napi.createArrayFrom;
pub const createObjectFrom = to_napi.createObjectFrom;
pub const createUnion = to_napi.createUnion;
pub const createFunction = to_napi.createFunction;
pub const createNapiValue = to_napi.createNapiValue;

pub const getValueInt = from_napi.getValueInt;
pub const getValueFloat = from_napi.getValueFloat;
pub const getValueArray = from_napi.getValueArray;
pub const getValue = from_napi.getValue;

// MARK: dumb wrappers

pub const toBool = wrappers._toBool;
pub const toNumber = wrappers._toNumber;
pub const toObject = wrappers._toObject;
pub const toString = wrappers._toString;
pub const createArray = wrappers._createArray;
pub const createBigintI64 = wrappers._createBigintI64;
pub const createBigintU64 = wrappers._createBigintU64;
pub const createBigintWords = wrappers._createBigintWords;
pub const createDataview = wrappers._createDataview;
pub const createDate = wrappers._createDate;
pub const createDouble = wrappers._createDouble;
pub const createError = wrappers._createError;
pub const createI32 = wrappers._createI32;
pub const createI64 = wrappers._createI64;
pub const createObject = wrappers._createObject;
pub const createRangeError = wrappers._createRangeError;
pub const createReference = wrappers._createReference;
pub const createStringLatin1 = wrappers._createStringLatin1;
pub const createStringUtf16 = wrappers._createStringUtf16;
pub const createStringUtf8 = wrappers._createStringUtf8;
pub const createSymbol = wrappers._createSymbol;
pub const createTypeError = wrappers._createTypeError;
pub const createU32 = wrappers._createU32;
pub const defineProperties = wrappers._defineProperties;
pub const deleteElement = wrappers._deleteElement;
pub const deleteProperty = wrappers._deleteProperty;
pub const deleteReference = wrappers._deleteReference;
pub const detachArraybuffer = wrappers._detachArraybuffer;
pub const escapeHandle = wrappers._escapeHandle;
pub const fatalError = wrappers._fatalError;
pub const fatalException = wrappers._fatalException;
pub const getAllPropertyNames = wrappers._getAllPropertyNames;
pub const getAndClearLastException = wrappers._getAndClearLastException;
pub const getArrayLength = wrappers._getArrayLength;
pub const getBoolean = wrappers._getBoolean;
pub const getDateValue = wrappers._getDateValue;
pub const getElement = wrappers._getElement;
pub const getGlobal = wrappers._getGlobal;
pub const getInstanceData = wrappers._getInstanceData;
pub const getLastErrorInfo = wrappers._getLastErrorInfo;
pub const getNamedProperty = wrappers._getNamedProperty;
pub const getNewTarget = wrappers._getNewTarget;
pub const getNodeVersion = wrappers._getNodeVersion;
pub const getNull = wrappers._getNull;
pub const getProperty = wrappers._getProperty;
pub const getPropertyNames = wrappers._getPropertyNames;
pub const getPrototype = wrappers._getPrototype;
pub const getReferenceValue = wrappers._getReferenceValue;
pub const getUndefined = wrappers._getUndefined;
pub const getUvEventLoop = wrappers._getUvEventLoop;
pub const getValueBigintI64 = wrappers._getValueBigintI64;
pub const getValueBigintU64 = wrappers._getValueBigintU64;
pub const getValueBigintWords = wrappers._getValueBigintWords;
pub const getValueBool = wrappers._getValueBool;
pub const getValueDouble = wrappers._getValueDouble;
pub const getValueExternal = wrappers._getValueExternal;
pub const getValueI32 = wrappers._getValueI32;
pub const getValueI64 = wrappers._getValueI64;
pub const getValueStringLatin1 = wrappers._getValueStringLatin1;
pub const getValueStringUtf16 = wrappers._getValueStringUtf16;
pub const getValueStringUtf8 = wrappers._getValueStringUtf8;
pub const getValueU32 = wrappers._getValueU32;
pub const getVersion = wrappers._getVersion;
pub const hasElement = wrappers._hasElement;
pub const hasNamedProperty = wrappers._hasNamedProperty;
pub const hasOwnProperty = wrappers._hasOwnProperty;
pub const hasProperty = wrappers._hasProperty;
pub const instanceOf = wrappers._instanceOf;
pub const isArray = wrappers._isArray;
pub const isArraybuffer = wrappers._isArraybuffer;
pub const isBuffer = wrappers._isBuffer;
pub const isDataview = wrappers._isDataview;
pub const isDate = wrappers._isDate;
pub const isDetachedArraybuffer = wrappers._isDetachedArraybuffer;
pub const isError = wrappers._isError;
pub const isExceptionPending = wrappers._isExceptionPending;
pub const isPromise = wrappers._isPromise;
pub const isTypedarray = wrappers._isTypedarray;
pub const newInstance = wrappers._newInstance;
pub const objectFreeze = wrappers._objectFreeze;
pub const objectSeal = wrappers._objectSeal;
pub const referenceRef = wrappers._referenceRef;
pub const referenceUnref = wrappers._referenceUnref;
pub const removeWrap = wrappers._removeWrap;
pub const runScript = wrappers._runScript;
pub const setElement = wrappers._setElement;
pub const setNamedProperty = wrappers._setNamedProperty;
pub const setProperty = wrappers._setProperty;
pub const strictEquals = wrappers._strictEquals;
pub const throw = wrappers._throw;
pub const throwError = wrappers._throwError;
pub const throwRangeError = wrappers._throwRangeError;
pub const throwTypeError = wrappers._throwTypeError;
pub const typeTagObject = wrappers._typeTagObject;
pub const typeOf = wrappers._typeOf;
pub const unwrap = wrappers._unwrap;
pub const wrap = wrappers._wrap;
pub const createPropertyKeyLatin1 = wrappers._createPropertyKeyLatin1;
pub const createPropertyKeyUtf16 = wrappers._createPropertyKeyUtf16;
pub const createPropertyKeyUtf8 = wrappers._createPropertyKeyUtf8;
pub const symbolFor = wrappers._symbolFor;
