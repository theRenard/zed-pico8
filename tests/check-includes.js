#!/usr/bin/env node
// Start the pico8-ls server on tests/fixtures/includes, open lua/main.lua like an editor
// does, and fail if the server reports any diagnostic (undefined variable, bad #include).
// Usage: node tests/check-includes.js /path/to/pico8-ls-server.js [fixture-subdir] [file-to-open]
// Defaults: fixtures/includes, lua/main.lua
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const url = require('url');

const server = process.argv[2];
if (!server) { console.error('usage: check-includes.js <path to pico8-ls-server.js>'); process.exit(2); }
const root = path.join(__dirname, 'fixtures', process.argv[3] || 'includes');
const rootUri = url.pathToFileURL(root).href;
const main = path.join(root, process.argv[4] || path.join('lua', 'main.lua'));

const p = spawn('node', [server, '--stdio']);
let buf = Buffer.alloc(0);
const diags = {};
const send = (m) => { const b = JSON.stringify(m); p.stdin.write(`Content-Length: ${Buffer.byteLength(b)}\r\n\r\n${b}`); };

p.stdout.on('data', (d) => {
  buf = Buffer.concat([buf, d]);
  for (;;) {
    const i = buf.indexOf('\r\n\r\n');
    if (i < 0) return;
    const n = +/Content-Length: (\d+)/.exec(buf.slice(0, i).toString())[1];
    if (buf.length < i + 4 + n) return;
    const m = JSON.parse(buf.slice(i + 4, i + 4 + n));
    buf = buf.slice(i + 4 + n);
    if (m.method === 'textDocument/publishDiagnostics') diags[m.params.uri] = m.params.diagnostics;
    if (m.method === 'workspace/workspaceFolders') send({ jsonrpc: '2.0', id: m.id, result: [{ uri: rootUri, name: 'fixtures' }] });
    else if (m.method === 'workspace/configuration') send({ jsonrpc: '2.0', id: m.id, result: m.params.items.map(() => ({ maxNumberOfProblems: 1000 })) });
    else if (m.method && m.id !== undefined) send({ jsonrpc: '2.0', id: m.id, result: null });
    if (m.id === 1 && m.result) {
      send({ jsonrpc: '2.0', method: 'initialized', params: {} });
      setTimeout(() => {
        send({ jsonrpc: '2.0', method: 'textDocument/didOpen', params: { textDocument: { uri: url.pathToFileURL(main).href, languageId: 'pico-8', version: 1, text: fs.readFileSync(main, 'utf8') } } });
        setTimeout(report, 3000);
      }, 3000);
    }
  }
});

function report() {
  const all = Object.entries(diags).flatMap(([u, ds]) => ds.map((d) => `${path.relative(root, url.fileURLToPath(u))}:${d.range.start.line + 1} ${d.message}`));
  console.log(`files with published diagnostics: ${Object.keys(diags).length}, problems: ${all.length}`);
  all.forEach((l) => console.log('  ' + l));
  p.kill();
  process.exit(all.length ? 1 : 0);
}

send({ jsonrpc: '2.0', id: 1, method: 'initialize', params: { processId: null, rootUri, workspaceFolders: [{ uri: rootUri, name: 'fixtures' }], capabilities: { workspace: { configuration: true, workspaceFolders: true } } } });
