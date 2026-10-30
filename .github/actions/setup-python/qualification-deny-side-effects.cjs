const moduleApi = require("node:module");
const deny = () => {
  throw new Error("QUALIFICATION_EXTERNAL_SIDE_EFFECT_BLOCKED");
};
for (const name of ["http", "https"]) {
  const m = require("node:" + name);
  m.request = deny;
  m.get = deny;
}
const net = require("node:net");
net.connect = deny;
net.createConnection = deny;
net.Socket.prototype.connect = deny;
net.Server.prototype.listen = deny;
const cp = require("node:child_process");
for (const k of ["spawn", "spawnSync", "exec", "execSync", "execFile", "execFileSync", "fork"]) cp[k] = deny;
globalThis.fetch = deny;
moduleApi.syncBuiltinESMExports();
