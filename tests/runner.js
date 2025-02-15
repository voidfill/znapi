const mod = require("../zig-out/test/zig_module.node");

console.log(mod);

import { expect, test } from "vitest";

test("module basics", () => {
	expect(mod).toBeTypeOf("object");
});

test("converting integers", () => {
	expect(mod.integers.u0).toBe(0);
	expect(mod.integers.u1).toBe(1);
	expect(mod.integers.i1).toBe(-1);
	expect(mod.integers.u32).toBe(3);
	expect(mod.integers.i32).toBe(-3);

	expect(mod.integers.pu0(0)).toBe(0);
	expect(mod.integers.pu1(1)).toBe(1);
	expect(mod.integers.pi1(-1)).toBe(-1);
	expect(mod.integers.pu32(3)).toBe(3);
	expect(mod.integers.pi32(-3)).toBe(-3);
});

test("converting bigints", () => {
	expect(mod.bigints.u64).toBe(3n);
	expect(mod.bigints.i64).toBe(-3n);
	expect(mod.bigints.u128).toBe(3n);
	expect(mod.bigints.u1234).toBe(3n);
	expect(mod.bigints.i1234).toBe(-3n);

	expect(mod.bigints.pu64(3n)).toBe(3n);
	expect(mod.bigints.pi64(-3n)).toBe(-3n);
	expect(mod.bigints.pu128(3n)).toBe(3n);
	expect(mod.bigints.pu1234(3n)).toBe(3n);
	expect(mod.bigints.pi1234(-3n)).toBe(-3n);
});

test("converting floats", () => {
	expect(mod.floats.f16).toBeCloseTo(3.14);
	expect(mod.floats.f32).toBeCloseTo(3.14);
	expect(mod.floats.f64).toBeCloseTo(3.14);

	expect(mod.floats.pf16(3.14)).toBeCloseTo(3.14);
	expect(mod.floats.pf32(3.14)).toBeCloseTo(3.14);
	expect(mod.floats.pf64(3.14)).toBeCloseTo(3.14);
});

test("converting undefined/null", () => {
	expect(mod.undefined).toBeUndefined();
	expect(mod.null.null).toBeNull();
	expect(mod.null.pnull(null)).toBeNull();
});

test("converting booleans", () => {
	expect(mod.bools.true).toBe(true);
	expect(mod.bools.false).toBe(false);
	expect(mod.bools.ptrue(true)).toBe(true);
	expect(mod.bools.pfalse(false)).toBe(false);
});

test("converting strings", () => {
	expect(mod.strings.empty).toBe("");
	expect(mod.strings.single).toBe("a");
	expect(mod.strings.multi).toBe("abc");
	expect(mod.strings.multi_utf8).toBe("😀😁😂🤣😃😄😅😆😉😊😋😎😍😘🥰😗😙😚");

	expect(mod.strings.psingle("a")).toBe("a");
	expect(mod.strings.pmulti("abc")).toBe("abc");
	expect(mod.strings.pmulti_utf8("😀😁😂🤣😃😄😅😆😉😊😋😎😍😘🥰😗😙😚")).toBe("😀😁😂🤣😃😄😅😆😉😊😋😎😍😘🥰😗😙😚");
});

test("converting arrays", () => {
	expect(mod.arrays.empty).toEqual([]);
	expect(mod.arrays.single).toEqual([1]);
	expect(mod.arrays.multi).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	expect(mod.arrays.large).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	expect(mod.arrays.vector).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	expect(mod.arrays.tuple).toEqual([1, 2n, 3]);
	expect(mod.arrays.slice).toEqual([2, 3]);

	expect(mod.arrays.pempty([])).toEqual([]);
	expect(mod.arrays.psingle([1])).toEqual([1]);
	expect(mod.arrays.pmulti([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	expect(mod.arrays.plarge([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])).toEqual([
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
	]);
	expect(mod.arrays.pvector([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
	expect(mod.arrays.ptuple([1, 2, 3])).toEqual([1, 2, 3]);
	expect(mod.arrays.pslice([2, 3])).toEqual([2, 3]);
});

test("converting objects", () => {
	expect(mod.structs.single).toEqual({ a: 1 });
	expect(mod.structs.multi).toEqual({ a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 });

	expect(mod.structs.psingle({ a: 1 })).toEqual({ a: 1 });
	expect(mod.structs.pmulti({ a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9, j: 10 })).toEqual({
		a: 1,
		b: 2,
		c: 3,
		d: 4,
		e: 5,
		f: 6,
		g: 7,
		h: 8,
		i: 9,
		j: 10,
	});
});

test("converting unions to js objects", () => {
	expect(mod.unions.un1).toEqual({ a: undefined });
	expect(mod.unions.un2).toEqual({ aa: undefined });
	expect(mod.unions.un3).toEqual({ b: 2431n });

	expect(mod.unions.pun1({ a: undefined })).toEqual({ a: undefined });
	expect(mod.unions.pun2({ aa: undefined })).toEqual({ aa: undefined });
	expect(mod.unions.pun3({ b: 2431n })).toEqual({ b: 2431n });
});

test("converting optionals", () => {
	expect(mod.optionals.empty).toBeNull();
	expect(mod.optionals.filled).toBe(1);

	expect(mod.optionals.pempty(null)).toBeNull();
	expect(mod.optionals.pfilled(1)).toBe(1);
});

test("converting enums", () => {
	expect(mod.enums.en1).toBe(42);
	expect(mod.enums.en2).toBe(123);

	expect(mod.enums.pen1(42)).toBe(42);
	expect(mod.enums.pen2(123)).toBe(123);
});
