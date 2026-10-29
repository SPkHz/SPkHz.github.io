const assert = require("node:assert/strict");
const merge = require(process.argv[2]);
const poisoned = JSON.parse('{"__proto__":{"polluted":"sentinel"},"safe":1}');
for (const [target, source] of [
  [Object.create(null), poisoned],
  [poisoned, { other: 2 }],
  [{}, { nested: poisoned }],
]) {
  const r = merge(target, source);
  assert.equal(Object.getPrototypeOf(r), Object.prototype);
  assert.equal(r.polluted, undefined);
  if (r.nested) {
    assert.equal(Object.getPrototypeOf(r.nested), Object.prototype);
    assert.equal(r.nested.polluted, undefined);
  }
}
assert.deepEqual(merge({ a: [1], b: { c: 2 } }, { a: [2], b: { d: 3 } }), { a: [1, 2], b: { c: 2, d: 3 } });
const sym = Symbol("x");
assert.equal(merge({}, { [sym]: 4 })[sym], 4);
assert.deepEqual(merge.all([{ a: 1 }, { b: 2 }]), { a: 1, b: 2 });
console.log("prototype safety and ordinary merge contract passed");
