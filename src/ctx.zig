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

env: n.env,
null: n.value,
undefined: n.value,
global: n.value,
true: n.value,
false: n.value,

/// Creates a new context allocated with the given allocator
pub fn create(env: n.env, allocator: std.mem.Allocator) !*Self {
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
pub const getValueStruct = from_napi.getValueStruct;
pub const getValueUnion = from_napi.getValueUnion;

// MARK: dumb wrappers

pub const toBool = wrappers.toBool;
pub const toNumber = wrappers.toNumber;
pub const toObject = wrappers.toObject;
pub const toString = wrappers.toString;
pub const createArray = wrappers.createArray;
pub const createBigintI64 = wrappers.createBigintI64;
pub const createBigintU64 = wrappers.createBigintU64;
pub const createBigintWords = wrappers.createBigintWords;
pub const createDataview = wrappers.createDataview;
pub const createDate = wrappers.createDate;
pub const createDouble = wrappers.createDouble;
pub const createError = wrappers.createError;
pub const createI32 = wrappers.createI32;
pub const createI64 = wrappers.createI64;
pub const createObject = wrappers.createObject;
pub const createRangeError = wrappers.createRangeError;
pub const createReference = wrappers.createReference;
pub const createStringLatin1 = wrappers.createStringLatin1;
pub const createStringUtf16 = wrappers.createStringUtf16;
pub const createStringUtf8 = wrappers.createStringUtf8;
pub const createSymbol = wrappers.createSymbol;
pub const createTypeError = wrappers.createTypeError;
pub const createU32 = wrappers.createU32;
pub const defineProperties = wrappers.defineProperties;
pub const deleteElement = wrappers.deleteElement;
pub const deleteProperty = wrappers.deleteProperty;
pub const deleteReference = wrappers.deleteReference;
pub const detachArraybuffer = wrappers.detachArraybuffer;
pub const escapeHandle = wrappers.escapeHandle;
pub const fatalError = wrappers.fatalError;
pub const fatalException = wrappers.fatalException;
pub const getAllPropertyNames = wrappers.getAllPropertyNames;
pub const getAndClearLastException = wrappers.getAndClearLastException;
pub const getArrayLength = wrappers.getArrayLength;
pub const getBoolean = wrappers.getBoolean;
pub const getCallbackArgs = wrappers.getCallbackArgs;
pub const getDateValue = wrappers.getDateValue;
pub const getElement = wrappers.getElement;
pub const getGlobal = wrappers.getGlobal;
pub const getInstanceData = wrappers.getInstanceData;
pub const getLastErrorInfo = wrappers.getLastErrorInfo;
pub const getNamedProperty = wrappers.getNamedProperty;
pub const getNewTarget = wrappers.getNewTarget;
pub const getNodeVersion = wrappers.getNodeVersion;
pub const getNull = wrappers.getNull;
pub const getProperty = wrappers.getProperty;
pub const getPropertyNames = wrappers.getPropertyNames;
pub const getPrototype = wrappers.getPrototype;
pub const getReferenceValue = wrappers.getReferenceValue;
pub const getUndefined = wrappers.getUndefined;
pub const getUvEventLoop = wrappers.getUvEventLoop;
pub const getValueBigintI64 = wrappers.getValueBigintI64;
pub const getValueBigintU64 = wrappers.getValueBigintU64;
pub const getValueBigintWords = wrappers.getValueBigintWords;
pub const getValueBool = wrappers.getValueBool;
pub const getValueDouble = wrappers.getValueDouble;
pub const getValueExternal = wrappers.getValueExternal;
pub const getValueI32 = wrappers.getValueI32;
pub const getValueI64 = wrappers.getValueI64;
pub const getValueStringLatin1 = wrappers.getValueStringLatin1;
pub const getValueStringUtf16 = wrappers.getValueStringUtf16;
pub const getValueStringUtf8 = wrappers.getValueStringUtf8;
pub const getValueU32 = wrappers.getValueU32;
pub const getVersion = wrappers.getVersion;
pub const hasElement = wrappers.hasElement;
pub const hasNamedProperty = wrappers.hasNamedProperty;
pub const hasOwnProperty = wrappers.hasOwnProperty;
pub const hasProperty = wrappers.hasProperty;
pub const instanceOf = wrappers.instanceOf;
pub const isArray = wrappers.isArray;
pub const isArraybuffer = wrappers.isArraybuffer;
pub const isBuffer = wrappers.isBuffer;
pub const isDataview = wrappers.isDataview;
pub const isDate = wrappers.isDate;
pub const isDetachedArraybuffer = wrappers.isDetachedArraybuffer;
pub const isError = wrappers.isError;
pub const isExceptionPending = wrappers.isExceptionPending;
pub const isPromise = wrappers.isPromise;
pub const isTypedarray = wrappers.isTypedArray;
pub const newInstance = wrappers.newInstance;
pub const objectFreeze = wrappers.objectFreeze;
pub const objectSeal = wrappers.objectSeal;
pub const referenceRef = wrappers.referenceRef;
pub const referenceUnref = wrappers.referenceUnref;
pub const removeWrap = wrappers.removeWrap;
pub const runScript = wrappers.runScript;
pub const setElement = wrappers.setElement;
pub const setNamedProperty = wrappers.setNamedProperty;
pub const setProperty = wrappers.setProperty;
pub const strictEquals = wrappers.strictEquals;
pub const throw = wrappers.throw;
pub const throwError = wrappers.throwError;
pub const throwRangeError = wrappers.throwRangeError;
pub const throwTypeError = wrappers.throwTypeError;
pub const typeTagObject = wrappers.typeTagObject;
pub const typeOf = wrappers.typeOf;
pub const unwrap = wrappers.unwrap;
pub const wrap = wrappers.wrap;
pub const createPropertyKeyLatin1 = wrappers.createPropertyKeyLatin1;
pub const createPropertyKeyUtf16 = wrappers.createPropertyKeyUtf16;
pub const createPropertyKeyUtf8 = wrappers.createPropertyKeyUtf8;
pub const symbolFor = wrappers.symbolFor;
