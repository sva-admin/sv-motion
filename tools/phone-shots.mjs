// phone-shots.mjs: real phone screenshots of a live site, no extra installs.
// Needs only Node 22+ and the Chrome that HyperFrames already downloaded.
//
//   node tools/phone-shots.mjs <url> <outDir> <name>=<scrollY or #selector> ...
//   node tools/phone-shots.mjs https://order-di-home.apps.sv-academy.org/ assets/phone hero=0 flow=#flow
//   name=<pixels>   scroll that far down, then shoot the phone screen
//   name=#id        scroll to that section, then shoot
//   name=@selector  shoot one element (a logo) on a transparent background, 8x (sharp for text or SVG; a raster logo only gets upscaled, check its natural size)
//
// Each shot is 390x844 CSS px (an iPhone-sized viewport) at 3x = 1170x2532 JPEG.
// Element shots (@selector) are transparent PNG.
// How it works: starts Chrome headless with a DevTools port, then talks to it
// over the built-in WebSocket (Node 22): emulate a phone, load, scroll, screenshot.
import { spawn, execSync } from "node:child_process";
import { mkdirSync, writeFileSync, mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const [url, outDir = "assets/phone", ...specs] = process.argv.slice(2);
if (!url || specs.length === 0) {
  console.error("usage: node tools/phone-shots.mjs <url> <outDir> name=<y|#selector> ...");
  process.exit(1);
}
const W = 390, H = 844, DPR = 3, PORT = 9333 + (process.pid % 500);
const SETTLE_MS = Number(process.env.SETTLE_MS || 1800);
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const chrome = execSync("npx -y hyperframes@0.8.75 browser path", { encoding: "utf8" }).trim().split("\n").pop();
const profile = mkdtempSync(join(tmpdir(), "phone-shots-"));
const proc = spawn(chrome, [
  "--headless", "--hide-scrollbars", "--no-first-run", "--mute-audio",
  `--remote-debugging-port=${PORT}`, `--user-data-dir=${profile}`,
  `--window-size=${W},${H}`, "about:blank",
], { stdio: "ignore" });

let ws, nextId = 0;
const pending = new Map();
const waiters = [];
function send(method, params = {}) {
  const id = ++nextId;
  ws.send(JSON.stringify({ id, method, params }));
  return new Promise((resolve, reject) => pending.set(id, { resolve, reject }));
}
function waitEvent(name, timeoutMs = 30000) {
  return new Promise((resolve) => {
    const t = setTimeout(() => resolve(null), timeoutMs);
    waiters.push({ name, resolve: (p) => { clearTimeout(t); resolve(p); } });
  });
}

try {
  let target;
  for (let i = 0; i < 50 && !target; i++) {
    await sleep(200);
    try {
      const list = await (await fetch(`http://127.0.0.1:${PORT}/json/list`)).json();
      target = list.find((t) => t.type === "page");
    } catch {}
  }
  if (!target) throw new Error("Chrome did not open a DevTools port");
  ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((r, j) => { ws.onopen = r; ws.onerror = j; });
  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      const p = pending.get(msg.id); pending.delete(msg.id);
      msg.error ? p.reject(new Error(msg.error.message)) : p.resolve(msg.result);
    } else if (msg.method) {
      for (let i = waiters.length - 1; i >= 0; i--) {
        if (waiters[i].name === msg.method) { waiters[i].resolve(msg.params); waiters.splice(i, 1); }
      }
    }
  };
  await send("Page.enable");
  await send("Emulation.setDeviceMetricsOverride", { width: W, height: H, deviceScaleFactor: DPR, mobile: true });
  await send("Emulation.setTouchEmulationEnabled", { enabled: true, maxTouchPoints: 5 });
  const loaded = waitEvent("Page.loadEventFired", 60000);
  await send("Page.navigate", { url });
  await loaded;
  await send("Runtime.evaluate", { expression: "document.fonts.ready.then(() => true)", awaitPromise: true });
  await sleep(SETTLE_MS + 1000); // let the hero entrance animations finish
  mkdirSync(outDir, { recursive: true });
  for (const spec of specs) {
    const [name, where = "0"] = spec.split("=");
    if (where.startsWith("@")) {
      // name=@selector : one element (a logo or wordmark) on a transparent background, 8x (sharp for text or SVG; a raster logo only gets upscaled).
      const sel = where.slice(1);
      const rect = (await send("Runtime.evaluate", { returnByValue: true, expression: `(() => {
        const src = document.querySelector(${JSON.stringify(sel)});
        if (!src) return null;
        const holder = document.createElement("div");
        holder.id = "__shot";
        holder.style.cssText = "position:fixed;left:0;top:0;padding:4px 6px;z-index:2147483647;display:inline-flex;background:transparent";
        holder.appendChild(src.cloneNode(true));
        const st = document.createElement("style");
        st.textContent = "html,body{background:transparent!important}body>*:not(#__shot){visibility:hidden!important}body::before,body::after{display:none!important}";
        document.head.appendChild(st);
        document.body.appendChild(holder);
        const r = holder.getBoundingClientRect();
        return { x: r.x, y: r.y, width: Math.ceil(r.width), height: Math.ceil(r.height) };
      })()` })).result.value;
      if (!rect) { console.error(`selector not found: ${sel}`); continue; }
      await send("Emulation.setDefaultBackgroundColorOverride", { color: { r: 0, g: 0, b: 0, a: 0 } });
      await sleep(300);
      const { data } = await send("Page.captureScreenshot", { format: "png", clip: { ...rect, scale: 8 / DPR } });
      const file = join(outDir, `${name}.png`);
      writeFileSync(file, Buffer.from(data, "base64"));
      console.log(`${file}  element=${sel}`);
      await send("Runtime.evaluate", { expression: `document.getElementById("__shot").remove(); document.head.lastElementChild.remove();` });
      await send("Emulation.setDefaultBackgroundColorOverride", {});
      continue;
    }
    const isSel = where.startsWith("#") || where.startsWith(".");
    const targetExpr = isSel
      ? `(() => { const el = document.querySelector(${JSON.stringify(where)}); return el ? Math.round(el.getBoundingClientRect().top + window.scrollY) : 0; })()`
      : String(Number(where));
    const ty = (await send("Runtime.evaluate", { expression: targetExpr, returnByValue: true })).result.value;
    const from = (await send("Runtime.evaluate", { expression: "window.scrollY", returnByValue: true })).result.value;
    const steps = Math.max(1, Math.ceil(Math.abs(ty - from) / 200));
    for (let s = 1; s <= steps; s++) {
      await send("Runtime.evaluate", { expression: `window.scrollTo(0, ${Math.round(from + ((ty - from) * s) / steps)})` });
      await sleep(40);
    }
    await sleep(SETTLE_MS);
    // Phone screens are JPEG (quality 92): sharp text, a fifth of the PNG size.
    const { data } = await send("Page.captureScreenshot", { format: "jpeg", quality: 92, captureBeyondViewport: false });
    const file = join(outDir, `${name}.jpg`);
    writeFileSync(file, Buffer.from(data, "base64"));
    const y = (await send("Runtime.evaluate", { expression: "window.scrollY", returnByValue: true })).result.value;
    console.log(`${file}  scrollY=${y}`);
  }
} catch (err) {
  console.error("phone-shots failed:", err.message);
  process.exitCode = 1;
} finally {
  try { ws && ws.close(); } catch {}
  proc.kill();
}
