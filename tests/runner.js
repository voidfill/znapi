const mod = require("../zig-out/test/zig_module.node");

console.log(mod);

import { expect, test } from "vitest";

test("module basics", () => {
	expect(mod).toBeTypeOf("object");
});
