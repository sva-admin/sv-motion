---
name: sv-motion
description: SV Academy's own video skill, one file. The video is one HTML text file an agent writes and a person can read, rendered to MP4 locally. Three ways in (a live website, a project's code, or a Remotion video to bring in), then a launch reel, the same video in 9:16, 16:9 and 1:1, a video per name on a list, captions timed to a recording, and slides presented from the file. Trigger on "SV Motion", "sv-motion", "launch reel", "launch video from my site", "turn my website into a video", "video from my code", "launch video from this project", "brag", "port my Remotion video", "convert Remotion to HyperFrames", "Remotion", "hyperframes", "video from a text file", "same video in three sizes", "personalised videos from a list", "render a batch", "make a video from this", "render this as an MP4", "animated title card", "captions from my recording", "present this as slides", "vertical clip for social".
---

# SV Motion. The video is a text file.

SV Academy's own working method for making video with an agent. Layout is markup, timing is attributes, motion is a script. Nothing is baked until the render, so changing a headline costs a re-render, not a re-shoot.

The engine is an open source tool that renders an HTML file to MP4. You never install it: every command runs it as `npx -y hyperframes@0.8.75 <command>`, and its own `npx -y hyperframes@0.8.75 docs` and `<command> --help` are the authority on flags.

This is one self contained file. Everything the skill needs is in here, including the three helper scripts (at the end, under "Helper scripts"): when a step needs one, write it to `tools/<name>` in the project first.

Free lesson, step by step: <https://loop.sv-academy.org/articles/video-from-a-text-file>

## Three ways in

Pick the way from what the person has. Ask only if you cannot tell.

| You have | Way | What you do |
| --- | --- | --- |
| A live website address | 1. From your live site | Preset 1 below, unchanged: capture the site, real phone screenshots, the launch reel. |
| The project's code on this machine (no public link needed) | 2. From your code | Read the code, find the product in use, plan a 15 to 25 s story, say the plan back, then build it from the project's real copy, colours, fonts and screens. See "Way 2" below. |
| A Remotion (React) video, from a template, a tutorial or another agent | 3. Bring in a Remotion video | Check the source for things that do not port; if any, say so and stop. Otherwise map it into one HTML file with the table in "Way 3" below, render both, compare stills side by side, and list anything that did not carry over. |

All three end in the same place: one HTML file in a project folder. From there everything in this file works on it: look first and fix it in words, every size from one file (Preset 2), one video per name on a list (Preset 3). The same kind of file also makes captions timed to a voice recording ("Captions from a recording") and slides presented from the laptop ("Slides you present from the file").

**About /brag.** `/brag` (<https://github.com/latent-spaces/brag>, MIT) is a popular skill that makes a launch video from a project's code. What it hands you decides the route:

- A `composition/` folder (classic `/brag` writes it inside `brag-output/`) whose `index.html` has `data-composition-id`: it is already the kind of file this skill works on. Skip way 3, run every command from that folder pinned to `@0.8.75`, and use the presets on it directly.
- A Remotion project (`registerRoot` in `src/`), from `/brag-slim` (its lighter mode, which builds with whatever tools are on the machine) or from any other agent: way 3 brings it into one HTML file.
- Anything else, such as a custom capture script or only a finished MP4: make the video again with way 2, from the product's code.

Way 2 is SV Academy's own take on the same idea, built directly as one HTML file.

If someone asks about Remotion: "Remotion is video in React for developers; SV Motion is one HTML file your agent writes and you can read. If you already have a Remotion video, way 3 brings it in."

## Pin the version: 0.8.75

Run every command as `npx -y hyperframes@0.8.75 <command>`. Never bare `npx hyperframes`, never `@latest`. A class of 13 on one Wi-Fi must get identical behaviour, and the engine ships often. Every method below was run against 0.8.75. Upgrade on purpose: change the pin, re-run the checks on a known project, then roll it out. `init` already pins the project's `npm run check` and `npm run render` scripts to 0.8.75.

The engine's own agent skills (on a machine where an earlier `init` installed them) may describe a newer CLI and other workflows. This file decides; on flags, trust `npx -y hyperframes@0.8.75 <command> --help`. Also in 0.8.75 but outside these presets: `render --format webm` (transparent overlay), `render --variables-file <file.json>`. `present` is covered in "Slides you present from the file".

## Pre-flight: run this first

```bash
node --version                        # v22 or newer
ffmpeg -version                       # any recent build
npx -y hyperframes@0.8.75 doctor
```

Must pass in `doctor`: Node.js, FFmpeg, FFprobe, Chrome, Memory, Disk, and a Version line that starts with 0.8.75. Crosses on whisper-cpp, TTS (Kokoro), BGM (MusicGen) and Docker are optional and fine. A cross on Version that only says a newer release is available (`0.8.75 -> 0.8.82 available, Run: hyperframes upgrade`) is also expected with the pin: do not upgrade. So "Some checks failed" with only these crosses is normal and pre-flight has passed.

| Missing | macOS | Windows (from docs, not tested on Windows) |
| --- | --- | --- |
| Node 22+ | `brew install node`, or the LTS installer from nodejs.org | `winget install OpenJS.NodeJS.LTS` |
| FFmpeg, FFprobe | `brew install ffmpeg` (no Homebrew: install it from brew.sh first) | `winget install --id Gyan.FFmpeg -e`, or the build from ffmpeg.org on PATH |
| Chrome | `npx -y hyperframes@0.8.75 browser ensure` (add `--force` if a download broke) | same |
| Memory, Disk | close apps and tabs, free a few GB | same |

Before class, at home: run `doctor` and `browser ensure` once, so 13 people on one Wi-Fi only fetch the site. After any install, open a new terminal (or restart the agent) so the command is found. The user types every password, never the agent. Quote every path that has a space in it. Windows PowerShell (untested): `curl.exe`, not `curl` (an alias for Invoke-WebRequest there); set a variable first (`$env:SETTLE_MS=2600`); copy folders with `Copy-Item -Recurse`; run `tools/*.sh` in Git Bash or WSL. Renders send anonymous telemetry by default (per the CLI docs); `npx -y hyperframes@0.8.75 telemetry disable` turns it off. These presets never run `publish`, `cloud`, `lambda`, `cloudrun`, `auth` or `feedback`.

Way 2 and way 3 need nothing more for the video itself. To shoot screens of an app that only runs locally, the project's dev command must work, with its dependencies already installed or installed with the person's yes (way 2, step 7; a plain static site needs neither). To render the Remotion side for the comparison, the Remotion project's dependencies must install the same way, with the person's yes (way 3, step 5).

**Network.** Every way needs the internet: `npx` fetches the engine, `browser ensure` fetches Chrome, `capture` and the phone shots load the site, the Google Fonts route downloads fonts, and the scaffold's `index.html` loads GSAP (the animation library) from `cdn.jsdelivr.net` at every preview and render. `phone-shots.mjs` also starts Chrome with a DevTools port on `127.0.0.1`. An agent sandbox with the network off (Codex's default) blocks these: approve the commands when it asks, or start the agent with network access on.

### Scaffolding with `init` (every way)

Always scaffold like this (Windows PowerShell, untested: run `$env:HYPERFRAMES_SKIP_SKILLS=1` first, then the command without the prefix, and `Remove-Item` instead of `rm`):

```bash
HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@0.8.75 init <folder> --non-interactive --resolution portrait && rm <folder>/CLAUDE.md <folder>/AGENTS.md
```

- `<folder>` must be a new name. `init` refuses a folder that already exists and is not empty (`Directory already exists and is not empty`); the `&&` then skips the `rm`. Never run the `rm` on its own after that: in an existing project it deletes the project's own agent notes. Pick another name and run the line again.

- `HYPERFRAMES_SKIP_SKILLS=1` stops `init` from installing or refreshing the engine's own agent skills in the global skill folders of every agent on the machine (`~/.claude/skills`, `~/.agents/skills` and others; it prints "Linked skills into N other agent directories"). Without it `init` takes 16 to 20 s instead of 2 s, prints "Restart your AI agent", and a skill it installed can show up in the running session and pull the agent into a different workflow. With it, none of that happens (tested 29 Sep).
- `init` still writes `CLAUDE.md` and `AGENTS.md`: notes for other agents that route to other workflows, use unpinned `npx hyperframes` and link the engine maker's docs site. They are not part of the video. Delete both, as above. Keep `hyperframes.json` (the engine's settings file) and `package.json`.
- Ignore the "Get started" list `init` prints: it is for a different workflow. This skill decides, keeps the @0.8.75 pin, and never restarts the session.
- `--resolution` takes `portrait` (1080x1920), `landscape` (1920x1080) or `square` (1080x1080). Any other size: see Way 3, step 3.

## Classroom mode

1. Show the beat list first: plain sentences, seconds on each. Then carry on, unless the user asked to approve it. (Way 2 always says its plan back first; see below.)
2. Run `check` until it passes.
3. Give a scrubbable preview: `npx -y hyperframes@0.8.75 preview --background` prints `Studio http://localhost:3002/#project/<folder>`. Hand over that URL, not a file path. Stop it with `npx -y hyperframes@0.8.75 preview --stop` run from the project folder (from anywhere else: `preview "<project path>" --stop`, as the CLI prints).
   - Starting the preview can rewrite your HTML (seen at once on `index.html`, later on the reel file): it stamps `data-hf-id` on elements and normalises attributes (`data-layout-allow-overlap` becomes `data-layout-allow-overlap=""`, `&#183;` becomes `·`). Harmless, but re-read the file before the next edit and never match on text written before the preview. `check` does not change files.
   - Opening the Studio can start a render by itself (software GPU, 37.5 s on an M3 Max) that writes `renders/<project>_<timestamp>.mp4` and a `.meta.json`. It is not the user's video: ignore or delete it. On slow laptops close the Studio tab or run `preview --stop` before your own `render`.
4. Iterate with the preview and `snapshot`, not full renders. `render --quality draft` helps on slow laptops only; on an M3 Max it took 14 to 19 s, no faster than the final.
5. Small machine: `render --workers 2` (each worker is a Chrome process, about 256 MB). At 8 GB RAM or less, 0.8.75 drops to one worker by itself (`--low-memory-mode`). `--workers 1` gives the same frames, just slower (28.5 s against 14.1 s here).
6. Render the final at the default quality (`looks`, CRF 16; the log prints `standard`). No `--quality` flag.
7. Show six stills from the MP4 (`tools/stills.sh`, written from "Helper scripts") and say where the file is.
8. A share copy for LINE on mobile data (the 18 s master is 12 to 35 MB, more with heavy effects): `ffmpeg -i renders/reel-9x16.mp4 -c:v libx264 -crf 24 -preset medium -pix_fmt yuv420p -movflags +faststart -c:a copy renders/reel-9x16-share.mp4` (20 MB to 4.7 MB in 3 s, PSNR 46 dB against the master).

Reference timings (M3 Max, 0.8.75): 18 s 1080x1920 reel renders in 14.3 s, `check` 12.7 to 20 s, 5 phone screens 25 s, a 3-row batch of 7 s videos 30.1 s. A fresh agent reading this skill cold reached the Studio preview in 12.6 min and the first MP4 in 17.1 min; "make it 16:9" then took 2.7 min. A one sentence fix to an existing 12 s reel ("make my web address bigger on the last frame") changed one tween and re-rendered in 26 s. On an 8 GB laptop expect `check` at 1 to 2 min and a render of several minutes.

Measured on 29 Sep by fresh agents reading only this file (M3 Max): way 1 on sv-academy.org, preview at 11.8 min and MP4 at 12.3 min (render 18.4 s, 12.3 MB); way 2 from a static example product's code, preview at 8.9 min and MP4 at 9.8 min; way 3, a 6 s 1280x720 port, preview at 2.9 min and MP4 at 3.4 min (render 5.9 s). Heavy effects cost render time and file size: the way 2 reel, with `backdrop-filter`, a `mask-image` iris, SVG grain and 3D transforms throughout, rendered 18 s in 41.3 s (about 3x the reference) and weighed 33.7 MB. That is normal, not a fault; make the share copy.

## SV defaults

- **Their brand leads.** The owner's colours, fonts, wordmark and words, never SV Academy's. Copy colour values literally from the capture (way 1) or from the code (way 2), in the form the source uses: hex, `rgb()`, `hsl()` and `oklch()` all render the same in the video. One catch: `check`'s contrast audit reads only colours the browser reports as `rgb()` (hex, `rgb()` and `hsl()` all are), so with `oklch()`, `lab()`, `lch()` or `color()` text colours it checks nothing and still prints a tick (`0/0 text checks pass WCAG AA`). When you see `0/0`, judge contrast yourself on the snapshots, or convert those tokens to the exact same colour in hex so `check` can measure them.
- **Real assets only.** Real phone screenshots of the live site (or of the app running locally), the site's own photos, the site's own words (`visible-text.txt` in way 1, the project's own copy in way 2, word for word for any claim). No stock footage, no invented screenshots, prices, numbers or reviews. Site photos are often about 720 px wide: use them blurred as backgrounds or near native size in a frame, never blown up full screen. Invented sample data (batch rows) is called invented.
  - A real screen shows whatever the site says today. Read every screen you use: if it shows a date, price or offer that looks out of date, tell the person and leave that screen out (or ask them to update the site first). Never paint over a real screen.
  - People in site photos: use them only as the site already shows them, never make a child's face the subject, and ask the owner before featuring any identifiable person.
  - Lines you write yourself are allowed only where the site has no words for the job: the hook question (it may restate, in your words, the customer's pain the site describes, but it claims nothing the site does not say) and translations. Tell the person which lines are yours.
  - No emoji in lines you write. An emoji inside the product's own screens (real or rebuilt) stays: it is part of the product.
  - The product's own call to action may appear as the button it is in the product, even though nothing in a video links anywhere.
  - SV house style has no em or en dashes. When the site's own words carry one (an age range, or a dash between two clauses), set it with a hyphen, comma or colon in the lines you place on screen ("age 10-15"). Real screenshots stay as they are.
- **The site wins.** If the user's description and the live site (or the code) disagree (a "pet profile app" whose site is a grooming spa), follow the site's own words, say so, and ask whether a different page or app should be filmed.
- **Adult, editorial, plain.** These are business owners. Confident type, restrained motion, no emoji, stickers, cartoon bounce or cute mascots.
- **Thai typography.**
  - Use the site's Thai font from the capture (or from the code), shipped as local woff2 in `fonts/`.
  - No Thai face in `fonts-manifest.json` (or in the code) means the site's Thai shows in the phone's system font. Ship a free Google Thai face that matches the site's sans (Noto Sans Thai passed check, snapshot and render) as local woff2, and tell the user. The Google Fonts route, tested 25 Sep:
    ```bash
    UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36'
    curl -sSL -A "$UA" "https://fonts.googleapis.com/css2?family=Noto+Sans+Thai:wght@400;600;700" -o thai.css
    # the url(...) under the /* thai */ comment is one variable woff2 for weights 100 to 900
    curl -sSL -o fonts/noto-sans-thai.woff2 "<that url>"
    ```
  - Generous line height. For masked reveals give each `.mask` `padding: 0.26em 0.06em 0.16em` and the matching negative margin, so tone marks (ไม้ตรี on โต๊ะ, ไม้จัตวา on ก๋วยเตี๋ยว) and lower vowels are never cut by `overflow: hidden`.
  - No `letter-spacing` and no `text-transform` on Thai. Thai has no spaces between words, so set display lines by hand, one element per line, split at phrase boundaries.
  - Check the marks on a close crop of one line element (for example the Thai hook line `#h4`): `npx -y hyperframes@0.8.75 snapshot --at <seconds> --zoom "#<line-id>" --no-end -o snapshots/marks`. The crop is the element's box, so a full-width line gives a wide strip (2844x387 in one run); still readable. Zoom on a full-frame layer gives the whole frame at 3x (3240x5760), not a crop.
  - Check the captured subsets. A Thai subset may have no Latin or digits (one test site's upright Thai serif had none), so set English and digits in a face that covers them. If a weight the site uses is missing from the capture, tell the user and fetch it by the Google Fonts route above, or use the nearest captured weight.
  - `fonts-manifest.json` does not say which subset a file covers: captured files have hash names, several can be labelled "Regular 400", and a variable font may be labelled by its lightest weight ("Thin 100"). Do not guess. Either fetch the family by the Google Fonts route (its CSS names the `/* thai */` file, often the very file the capture holds), or test a candidate: set one Thai line in that file alone and look at a `snapshot` close crop; a file without Thai shows the fallback face.
- **Bilingual order.** Thai line first, English second, unless the site is English first. Hook, captions and tagline all follow this order. When the site has no wording in one language for a line (an English-first site often has only a motto in Thai), translate the site's own words faithfully, tell the user which lines are your translation, and ask the owner to approve them before the video is shared.
  - The person's prompt decides the languages ("Captions in Thai and English"). If it says nothing and the product is English only for an English speaking market, ask whether they want Thai at all; if you cannot ask, add Thai as the second line and flag every Thai line as your translation.
- **Last frame.** Wordmark, the site's own offer line, and the live address as plain text (for example `sv-academy.org`), on screen for at least two seconds. No live address (way 2 on an unpublished app): the product name or the project's own call to action, never an invented URL. In 9:16 size the group to hold the tall frame, not a small cluster between empty bands.
- **Tag.** A small, quiet "Made with SV Motion" on the last frame. The user may remove it.

## Preset 1: launch reel from a live site, 9:16 (way 1)

Keep the capture beside the project, not inside it (the capture ships its own CLAUDE.md that points to a different workflow; ignore it, this skill decides).

1. **Scaffold and capture**, from a work folder (see "Scaffolding with `init`" for why the prefix and the `rm`):
   ```bash
   HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@0.8.75 init launch-reel --non-interactive --resolution portrait && rm launch-reel/CLAUDE.md launch-reel/AGENTS.md
   npx -y hyperframes@0.8.75 capture https://<name>.apps.sv-academy.org/ -o capture --skip-vision
   ```
2. **Brand from the capture.** Read `capture/extracted/tokens.json` (colours, fonts), `design-styles.json` (type scale, radii, shadows), `fonts-manifest.json` and `visible-text.txt`, and look at `capture/screenshots/contact-sheet-1.jpg` and `capture/assets/contact-sheet.jpg`. Copy the fonts and photos you use into `launch-reel/fonts/` and `launch-reel/assets/`: paths resolve from the project root. Capture screenshots are desktop 1920x1080 only (`capture` has no viewport option), so they are brand data, not phone screens.
   - **Logo.** Find it in `capture/extracted/page.html` and check its natural size. A capture line like `Dropped: 1 (1 size-floor)` means a small image was skipped, often the logo. If it is a small raster (one test site's was a 300x85 PNG), fetch the original (`curl -sSL -o assets/brand/logo.png "<src>"`; `-L` follows the redirect to storage), use it at no more than about 1.2x, and let the brand name, set as live text in the site's font beside it, carry the size, the way the site's header pairs them. An `@selector` shot only upscales a raster logo into a blur; it is sharp for text or SVG wordmarks.
3. **Phone screens.** Write all three helper scripts from "Helper scripts" at the end of this file into `launch-reel/tools/`: `phone-shots.mjs`, `stills.sh`, `make-sound.sh`. `phone-shots.mjs` needs only Node 22 and the Chrome the engine downloads (`browser ensure`). From `launch-reel/`:
   ```bash
   # survey: a screen every 700 px, open them, pick the real moments
   SETTLE_MS=2600 node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/survey s0=0 s1=700 s2=1400 s3=2100 s4=2800
   # final shots at the positions you picked (for example hero=0 floor=1400 order=2100 kitchen=2450 pay=2950)
   SETTLE_MS=2600 node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/phone hero=0 floor=1400
   # the real wordmark as a transparent PNG (find the logo's selector in capture/extracted/page.html)
   node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/brand wordmark=@.brand
   ```
   Each shot is a 390x844 phone at 3x (1170x2532 JPEG). `name=#section` scrolls to a section, `name=@selector` saves one element as a transparent PNG. It scrolls in 200 px steps so scroll-driven sections react; raise `SETTLE_MS` if cards are caught mid-animation.
   - **Overlays.** A cookie or consent banner, a floating chat button or any fixed widget shows up in every shot (and repeats down a stitched strip). Find its selector in the survey shots or `capture/extracted/page.html` and hide it: for example `HIDE=".cookie-banner,.chat-button" node tools/phone-shots.mjs ...` (comma separated CSS selectors). This hides with CSS only: never click Accept, never store consent. Use `HIDE` for fixed overlays only; hiding something in the page flow moves everything below it.
   - **Blank cards at a seam.** Scroll reveals below the part of the page the script scrolled through have not fired yet. `PRESCROLL=1` walks the whole page once before the first shot.
   - **One continuous scrolling screen.** Survey shots every 700 px do not tile. Shoot at `y = k x (844 - navHeight)`: with an 80 px fixed nav, `... assets/phone p0=0 p1=764 p2=1528 p3=2292`. `navHeight` is where the content below the nav is clean, not the nav's border: a nav with a drop shadow is taller than its box (a 58 px nav with a 14 px shadow is 72, so the step is 772). Look at the pixels under the nav in shot 1 before you pick it. At 3x, crop the nav from shot 0 into its own file (`ffmpeg -v error -i assets/phone/p0.jpg -vf crop=1170:240:0:0 -q:v 2 assets/screen/nav.jpg`) and each shot below the nav (`-vf crop=1170:2292:0:240` into `c0.jpg`, `c1.jpg` ...: 240 is `navHeight x 3`, 2292 is `(844 - navHeight) x 3`). With a shadowed nav, measured in one run: the nav file and tile 0 cut at the nav's visible height, tiles 1 and up at the clean line (174 and 216 at 3x for the 58 and 72 above). Check every seam in a snapshot. A sticky bottom bar: crop it too and subtract its height from the step. A floating widget: hide it with `HIDE`. Stack the crops as `<img>` elements in one `#strip` with `data-layout-ignore` (otherwise `check` warns `escaped_container`), pin the nav above it, and tween the strip's `y`. Offset = site px x screen scale: on a 585 px wide screen (1.5x), site 700 px is `y: -1050`.
   - Do not put the live URL in an iframe: every render worker reloads the site and its wall-clock animations jump at worker boundaries. Not deterministic, and it needs the network.
   - Do not iframe the capture's `page.html` (glitch frames, font 404s, top of page only), and do not use Chrome's `--screenshot` flag below the hero (blank frames).
   - If the site opens on a gate (login, name card), is one thin screen, or is not live yet, ask the user for two or three phone screenshots of the real screens, or use way 2 if the code is on this machine.
4. **Beat list**, 15 to 20 s. The verified 18 s shape:

   | Beat | Time | What happens |
   | --- | --- | --- |
   | Hook | 0 to 3 s | The customer's real pain as a question, in the bilingual order above, over a blurred real photo |
   | Reveal | 3 to 4.7 s | Soft iris into the brand world, wordmark, the site's one-line description |
   | Product | 4.7 to 12 s | Phone rises in 3D and scrolls the real screens, three callouts in the site's exact words, one or two camera push-ins on the detail that matters |
   | Tagline | 12 to 15 s | The site's promise, kinetic, in the bilingual order above |
   | Close | 15 to 18 s | Wordmark, offer line from the site, live address as text, "Made with SV Motion" |

5. **Build the reel in one file**, `compositions/reel.html`, as a `<template>` sub-composition; `index.html` is a thin host (canvas size, mounts the reel, music). Building it this way from the start makes Preset 2 free. The two skeletons below passed `lint`, `check` and `render` on 0.8.75 (the engine's own docs show no `<template>` example; follow these).

   `index.html`, the thin host. Keep `init`'s GSAP line: GSAP loads once, here, from the CDN, and the reel uses the host's copy (never load it again in the reel). The host keeps its own empty paused timeline.
   ```html
   <!doctype html>
   <html lang="th" data-resolution="portrait">
     <head>
       <meta charset="UTF-8" />
       <meta name="viewport" content="width=1080, height=1920" />
       <script src="https://cdn.jsdelivr.net/npm/gsap@3.14.2/dist/gsap.min.js"></script>
       <style>
         * { margin: 0; padding: 0; box-sizing: border-box; }
         html, body { margin: 0; width: 1080px; height: 1920px; overflow: hidden; background: #111; }
         #root { position: relative; width: 100%; height: 100%; overflow: hidden; }
         #el-reel { position: absolute; inset: 0; }
       </style>
     </head>
     <body>
       <div id="root" data-composition-id="main" data-start="0" data-duration="18" data-width="1080" data-height="1920">
         <div id="el-reel" data-composition-id="reel" data-composition-src="compositions/reel.html"
           data-start="0" data-duration="18" data-track-index="1" data-width="1080" data-height="1920"></div>
         <audio id="bed" class="clip" src="assets/audio/bed.wav" data-start="0" data-duration="18" data-track-index="2" data-volume="1"></audio>
       </div>
       <script>
         window.__timelines["main"] = gsap.timeline({ paused: true });
       </script>
     </body>
   </html>
   ```
   `compositions/reel.html`, the whole reel. Style, markup and script all sit inside the `<template>`; every CSS rule is scoped under `#reel-root`; paths (`fonts/`, `assets/`) resolve from the project root. The `<html>` tag is where Preset 2 and 3 put `data-composition-variables`.
   ```html
   <!doctype html>
   <html lang="th">
     <head><meta charset="UTF-8" /></head>
     <body>
       <template id="reel-template">
         <style>
           @font-face { font-family: "Brand Sans"; src: url("fonts/brand-sans.woff2") format("woff2"); font-weight: 400 700; }
           #reel-root { position: absolute; inset: 0; width: 100% !important; height: 100% !important; overflow: hidden; }
           #reel-root * { box-sizing: border-box; margin: 0; padding: 0; }
           #reel-root .scene { position: absolute; inset: 0; }
         </style>
         <div id="reel-root" data-composition-id="reel" data-start="0" data-duration="18" data-width="1080" data-height="1920">
           <div id="hook" class="scene clip" data-start="0" data-duration="3.3" data-track-index="0">...</div>
           <div id="reveal" class="scene clip" data-start="3.1" data-duration="1.8" data-track-index="1">...</div>
           <!-- product, each callout, tagline, close, each caption: one timed clip each, own track when they overlap -->
           <div id="fx" class="scene clip" data-start="0" data-duration="18" data-track-index="9" data-layout-ignore>...</div>
         </div>
         <script>
           (function () {
             const tl = gsap.timeline({ paused: true });
             gsap.set("#hook-line", { yPercent: 110, opacity: 0 });   // starting states, see Composing
             tl.to("#hook-line", { yPercent: 0, duration: 0.7, ease: "expo.out" }, 0.2);
             window.__timelines["reel"] = tl;
           })();
         </script>
       </template>
     </body>
   </html>
   ```
   Methods verified on the 25 Sep reference reel and the 29 Sep test runs (you do not need either project to follow them):
   - **Each beat is its own timed clip.** Hook, reveal, product, tagline, close and each caption: its own element with `class="clip"`, `data-start`, `data-duration` and `data-track-index`. Otherwise every scene's text exists at every time and the first `check` fails (a fresh run: 32 layout and 20 contrast errors). `check` does not understand a `mask-image` iris: keep the masked brand layer at opacity 0 until the iris starts, and put `data-layout-allow-overlap` on the text the iris deliberately covers. It goes on the exact element `check` names in its `content_overlap` error, usually the innermost span that holds the words; on a wrapper or a `.mask` row it does nothing (it is not inherited).
   - Depth: blurred photo and glows at the back, a giant ghost word drifting behind the phone, framed photos drifting at another speed, the phone with its own shadow and moving glare, callout cards in front, captions on top, then light leak, vignette and grain. The ghost word needs enough contrast in every size to read as a word, not texture.
   - 3D phone: `perspective` on a wrapper, `rotationX`/`rotationY` on the child. Camera: one wrapper whose x, y and scale you tween for push-ins.
   - Callouts and captions sit outside the camera wrapper (inside it, a push-in shoves a card past the 9:16 edge). One callout at a time: the next one's entrance is the previous one's exit. Place each beside the part of the phone screen it names, never over it.
   - Reveals: masked lines with `yPercent` plus `filter: blur()`. Never scale inside a mask (clips Thai). Soft iris: CSS `mask-image: radial-gradient(...)` driven by a custom property (`tl.fromTo(el, {"--iris":"0%"}, {"--iris":"160%"})`), not a hard `clip-path: circle()`.
   - Mark full-frame decoration (grain, vignette) with `data-layout-ignore`.
6. **Captions.** Two lines in the bilingual order above, the site's sans, first line semibold, second regular, on a dark glass pill: the brand's darkest ink at about 84% opacity with a 12 px backdrop blur. Captions carry words that are not already on screen. Hide them when the words are there already (tagline, close); when bilingual callouts carry the whole product beat, the reel needs no separate captions at all.
7. **Sound.** A music bed synthesised with FFmpeg, no samples and no licences: adapt `tools/make-sound.sh` (from "Helper scripts"; move its hit times to your beats). Add it as its own `<audio>` element in the host, around -16 LUFS. Leave it out when the user asks for a silent video.
8. **Gate**: `lint`, then `check` until it passes, then `snapshot --at <one time per beat> --no-end` and open the PNGs. Each run replaces the frame PNGs in its folder: use `-o snapshots/<name>` for frames you want to keep. Every line must stay on screen long enough to read (at least about 1.5 s); a reveal line gone in under a second is a defect.
9. **Preview**: start it and give the Studio URL (Classroom mode, step 3).
10. **Render and look**:
    ```bash
    npx -y hyperframes@0.8.75 render -o renders/reel-9x16.mp4
    ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration renders/reel-9x16.mp4
    bash tools/stills.sh renders/reel-9x16.mp4      # six stills plus a contact sheet in renders/stills/
    ```

## Way 2: a video from your code

For a project whose code is on this machine, live or not. The person opens the agent inside the project folder. The code is read, never changed: no commits, no pushes, no deploys, no database commands, no edits to the app. The only things you run in the project are its own install (only with the person's yes, see step 7) and its dev command, and only if you need screens. A plain static site (an `index.html` and a stylesheet, no `package.json`) has no dev command: you run nothing in it and shoot it straight from the file (step 7).

1. **Pre-flight** as above.
2. **Read the code.** In this order, and write down what you find:
   - What it is: whichever of these exist: `README`, `package.json` (name, description, scripts, framework), a brief such as `PRODUCT.md`, `BRIEF.md` or `docs/` (often the best source of who it is for and what it promises), the main page or entry route (`index.html` on a static site), the route list (`app/`, `pages/`, `src/routes/` or the router file).
   - Exact colours: CSS variables in the global stylesheet, the Tailwind config or theme file, design tokens. Copy the values literally, in the form the code uses (hex, `rgb()`, `hsl()`, `oklch()`: see "Their brand leads" for the contrast catch).
   - Exact fonts: `@font-face` rules, `next/font` calls, Google Fonts links, `@fontsource` packages. Copy the woff2 files the project already ships (`public/fonts/`, `node_modules/@fontsource/...`) into the video's `fonts/`, or fetch the same family by the Google Fonts route above.
   - Words: the real headlines, button labels, empty states and success messages in the components and any translation files. These are the only words the video may claim.
   - Pictures: the logo and images in `public/` or `assets/`. Check the logo's natural size (same rule as Preset 1).
3. **Find the product in use.** Three plain sentences: the entry (what a customer sees first), the key action (the one thing they do), the result (what they get). Name the file or route for each.
4. **Plan a 15 to 25 s story.** Hook 2 to 3 s (the customer's real pain, bilingual order), reveal (wordmark and the project's one line), 2 or 3 highlights (the entry, the key action, the result, each on a real screen with the project's exact words), outro with the live address or, without one, the product name and the project's own call to action. Give seconds for every beat.
5. **Say the plan back before building**: the three sentences, the beat list with seconds, the colours and fonts you found, which screens you will show and how you will get them. Then build, unless the person wants to change it.
6. **Scaffold beside the code, not inside it**, so nothing lands in the app's build or its git history: from the folder that holds the project, `HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@0.8.75 init <project>-video --non-interactive --resolution portrait && rm <project>-video/CLAUDE.md <project>-video/AGENTS.md` (use `landscape` if they asked for 16:9; see "Scaffolding with `init`": a new folder name only). Copy the fonts, logo and pictures you use into it.
7. **Screens**, from the video folder (write `tools/phone-shots.mjs` there, never into the app), best first:
   - **The app runs locally.** If `node_modules` is missing, ask the person before installing anything, then use `npm ci` (it installs exactly what the lockfile says and does not rewrite it; with no `package-lock.json`, ask which install command the project uses). If they say no, or it fails, use a static file or rebuild the screens from the code (below). Start it with its own dev command from the README or `package.json` (`npm run dev` or similar) and shoot phone screens of the local address with `tools/phone-shots.mjs`, exactly as in Preset 1 step 3 (`node tools/phone-shots.mjs http://localhost:<port>/ assets/phone hero=0 ...`). Stop the dev server when done. If it needs keys, a database or a login you do not have, do not invent them: use the next option.
   - **A static site** needs no server: give `phone-shots.mjs` the file's absolute address, `node tools/phone-shots.mjs "file:///<absolute path>/index.html" assets/phone hero=0 ...` (tested 29 Sep). If a page loads its data with `fetch` and comes out empty that way, serve the folder with any local static server instead; that does not change the project either.
   - **Rebuilt from the code.** The video is HTML, so a screen can be the project's own markup and styles copied in as static HTML with the real text: its header, its key card, its result state. Use the project's own sample or seed data, or label the data invented. Never draw a screen the product does not have.
   - **Mix real and rebuilt.** Real phone shots for most screens, and a rebuilt one where the real phone layout lets the product down (in one test the site's own 390 px layout cut the key ETA card to a single digit; that panel was rebuilt at 440 px from the project's own markup and CSS and read well). Tell the person which screens were rebuilt.
8. **Build, gate, preview, render and look** exactly as Preset 1 steps 5 to 10: the reel in `compositions/reel.html` with a thin `index.html` host, each beat its own timed clip, captions, optional sound, `lint`, `check`, `snapshot`, preview URL, render, `stills.sh`. Every SV default applies: their brand leads, real assets only, Thai typography, last frame, the tag.
9. Tell the person where the MP4 is, which lines were your translation, and which screens were rebuilt rather than shot.

## Way 3: bring in a Remotion video

For a Remotion (React) video from a template, a tutorial, `/brag` or another agent. The result is one HTML file in a fresh project. The mapping lives here; nothing else is installed.

1. **Find the video.** The Remotion entry (`src/index.ts` calls `registerRoot`) points at a root file (often `src/Root.tsx`) that lists each `<Composition>` with its `id`, `width`, `height`, `fps`, `durationInFrames` and `defaultProps`. If there are several, ask which one. Read that component and everything it imports from the project.
2. **Stop check.** Search the source for things that do not port to a seekable, frame exact render:
   ```bash
   grep -rnE "useState|useReducer|useEffect|useLayoutEffect|calculateMetadata|@mui/|@chakra-ui/|@mantine/|antd|@radix-ui/|@nextui-org/|components/ui/|@remotion/(three|lottie|skia|gif|rive|media-utils)" src
   ```
   - **Stop** on any of these and say so, naming the file and line: React state that drives the picture (`useState`, `useReducer`), `useEffect` or `useLayoutEffect` with dependencies, an async `calculateMetadata`, a third party UI component library (MUI, Chakra, Mantine, Ant Design, shadcn/ui, Radix, NextUI), or a Remotion package this file has no mapping for: `@remotion/three`, `@remotion/lottie`, `@remotion/skia`, `@remotion/gif`, `@remotion/rive`, `@remotion/media-utils` (`useAudioData` and `visualizeAudio` read audio data at run time). Offer the two honest options: keep that video in Remotion, or make a fresh one with way 2 from the product's code.
   - A `useEffect` with an empty dependency list that only sets things up once, and a synchronous `calculateMetadata`, are fine: resolve them by hand.
   - **Carry on but note it** for: `delayRender` and `continueRender` (drop them; load fonts and images before the timeline is built), Remotion Lambda config (drop it, it is deployment, not picture), `useMemo` and `useCallback` (plain values), `React.lazy` (a plain import), a volume function on `<Audio>` (a plain linear fade at the clip's start or end becomes `data-fade-in` or `data-fade-out` in seconds on the `<audio>` clip, tested 29 Sep; any other shape: bake it into the audio file with FFmpeg `afade` or `volume`), `playbackRate` on `<Video>`, `<OffthreadVideo>` or `<Audio>` (re-time the file with FFmpeg first), `loop` on them (repeat the clip, the count computed from the duration), a `<Loop>` whose child keeps state between loops (repeats will not match), `<Img crossOrigin="use-credentials">` (download the image first).
3. **Scaffold** beside the Remotion folder: `HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@0.8.75 init <name>-port --non-interactive --resolution <portrait|landscape|square> && rm <name>-port/CLAUDE.md <name>-port/AGENTS.md` (see "Scaffolding with `init`": a new folder name only). Everything goes into its `index.html`: one root, one timed clip per scene, one paused timeline.
   - **Other sizes.** `--resolution` knows only 1080x1920, 1920x1080 and 1080x1080. For any other size (a 1280x720 source), pick the nearest preset and change four places in `index.html` to the source's size: the root's `data-width` and `data-height`, the `html, body` CSS `width` and `height`, and the `<meta name="viewport" content="width=..., height=...">`.
   - **Frame rate, every size.** Put the source's `fps` on the root as `data-fps` (for example `data-fps="60"`). The render uses the root's `data-fps`, and without it renders at 30 fps: a 24, 25 or 60 fps source would come out at the wrong rate and drift against the Remotion render frame by frame (tested 29 Sep: `data-fps="25"` on a 2 s root gave 25/1 and 50 frames).
   - Keep the scaffold's `* { box-sizing: border-box; }` reset: Remotion measures boxes the same way (a card's padding sits inside its width), so deleting it makes every padded box bigger than the source.
   - `lint` gives one `nested_structure_needs_subcomposition` warning per scene in a one-file port. They are expected and harmless; the render is right. If you want them gone, or want Preset 2 sizes, move the content into `compositions/reel.html` with a thin host (Preset 1 step 5 skeletons).
   - **The source wins in a port.** Keep its timing even where "Composing" says otherwise (a first movement at frame 0 stays at 0), keep its colours even where `check` reports low contrast (write the finding in `PORT-NOTES.md`, do not change the colour), and add no "Made with SV Motion" tag unless the person asks. The SV defaults are for new videos; a port is a faithful copy.
4. **Map it**, with this table:

   | In Remotion | In the one HTML file |
   | --- | --- |
   | `<Composition width height fps durationInFrames>` | The root's `data-width` and `data-height` (plus the body CSS size and the viewport meta, step 3), and `data-fps` = the source's `fps` (without it the render is 30 fps); `data-duration` = `durationInFrames / fps` in seconds. Every frame number below becomes seconds the same way: `frame / fps`. |
   | `useVideoConfig()` | Constants from that `<Composition>`: `width`, `height`, `fps`, `durationInFrames`. |
   | `defaultProps` | Variables on `<html data-composition-variables>` with the same defaults, read once with `window.__hyperframes.getVariables()` (Preset 3 shows the form). |
   | `<Sequence from durationInFrames>`, `<Series>` | One element per scene with `class="clip"`, `data-start` = `from / fps`, `data-duration` = `durationInFrames / fps`, and a `data-track-index`. A `<Series>` is sequences laid end to end: add the lengths up. Scenes that overlap go on different tracks. |
   | A `<Sequence>` inside another | Its start is the sum of every ancestor's `from` plus its own. A `<Sequence>` with no `durationInFrames` runs to the end of its parent. |
   | `<Series.Sequence offset>` | Shifts that scene's start, and every scene after it, by `offset / fps`. A negative offset overlaps the scene before: put it on another track. |
   | `<AbsoluteFill>` | A `div` with `position: absolute; inset: 0; display: flex; flex-direction: column`. It is a column: the source's `justifyContent` is vertical and `alignItems` horizontal, so copy them onto the column as they are. |
   | Anything computed from `useCurrentFrame()` | A tween on the one paused timeline, placed at the scene's start plus the local frame over fps. The CSS holds the value at the scene's first frame; the tween moves it. |
   | `interpolate(frame, [a, b], [x, y])` | A tween from `x` to `y` with `duration: (b - a) / fps` and `ease: "none"`, placed at `start + a / fps`. Per element: one `gsap.set(el, {...every starting value})` before the timeline, then one `tl.to` per interpolate (same duration, ease and position). Use a single `tl.fromTo` only when the element has exactly one animated range: two on one element (opacity plus y, the common case) give lint `gsap_repeated_fromto_without_baseline`. An `easing` option becomes the matching ease (`Easing.out(Easing.cubic)` is `power2.out`, `Easing.inOut(Easing.ease)` is `sine.inOut`); `Easing.bezier(...)` becomes the nearest named ease, noted in `PORT-NOTES.md`. Several points in the ranges become several `tl.to` in a row. Check `extrapolateLeft` and `extrapolateRight`: Remotion's default is `"extend"`, so the value keeps changing past the range (`interpolate(60, [0, 30], [0, 100])` is 200). A clamped range maps as written. An unclamped one that is still visible after `b` needs a second linear tween at the same rate until the scene ends; before `a`, it starts from the extended value at the scene's first frame and moves at the same rate. |
   | `interpolate` on `width` or `height` (a bar or underline growing) | Rule 4 forbids tweening layout. Give the element its final size in CSS and tween `scaleX` (or `scaleY`) from `x / final` to 1, with `transform-origin` where the source grows from (`left center` for a bar growing right, `center` for one growing both ways). |
   | `spring()` | An eased tween: `back.out(s)` if the spring overshoots, `power3.out` if it settles without. Measure the real spring instead of guessing, inside the Remotion project (it ships the functions): `node -e 'const { spring, measureSpring } = require("remotion"); const fps = 30, config = { damping: 14, mass: 0.9 }; console.log("settles after", measureSpring({ fps, config }), "frames"); for (let f = 0; f <= 30; f++) console.log(f, spring({ frame: f, fps, config }).toFixed(3));'` with the source's own `fps` and `config`. The tween's length is the settle frame over fps; pick `s` by the peak: about 1.0 for a 3 to 4% overshoot, 1.2 for 5%, 1.4 for 7%, 1.7 for 10%, 2 for 13%. Then compare frames. (Tested: `damping: 14, mass: 0.9` peaks at 1.032 on frame 13 and settles by 21 to 23; `back.out(1.2)` over 24 frames matched by eye.) Never a `back` ease on opacity or filter (split the tween). |
   | `interpolateColors` | A tween on the colour property itself. |
   | `staticFile("x.png")`, the `public/` folder | Copy the file into `assets/` and use the relative path `assets/x.png`. |
   | `<Img>` | `<img>`. |
   | `<Video>`, `<OffthreadVideo>` | A muted `<video>` as its own timed clip; its sound, if any, as a separate `<audio>` clip. |
   | `<Audio>` | An `<audio>` clip with `data-start`, `data-duration` and `data-volume`. |
   | `trimBefore` (older: `startFrom`) on `<Video>`, `<OffthreadVideo>` or `<Audio>` | `data-media-start` = frames / fps on that clip (the offset into the file). |
   | `@remotion/google-fonts`, `loadFont()`, `@font-face` | The same family as local woff2 in `fonts/` with `@font-face` (Google Fonts route above). |
   | `<TransitionSeries>` with fade, slide or wipe | The two scenes overlap for the transition's length on two tracks; tween the old one out and the new one in over the same span. The total length is the sum of the scenes minus the sum of the transitions. |
   | A component used several times with props | The HTML repeated with each instance's values written in, or driven by variables. |

   Keep every rule in "Rules that keep a render reproducible" and "Composing". No `Math.random()` in the port even if the source used Remotion's seeded `random()`: use a seeded generator with a fixed seed.
5. **Render both.**
   ```bash
   # in the Remotion folder (its dependencies installed first, with the person's yes: `npm ci` when it has a lockfile);
   # the entry is the file that calls registerRoot. The output goes straight into the port folder beside it.
   npx remotion render src/index.ts <CompositionId> ../<name>-port/renders/remotion.mp4
   # in the port folder
   npx -y hyperframes@0.8.75 check
   npx -y hyperframes@0.8.75 render -o renders/port.mp4
   ```
6. **Compare stills side by side.** Every command in this step runs from the port folder. Write `tools/stills.sh` there, run it on both files, and open the two contact sheets together; for a moving comparison, one frame locked file:
   ```bash
   bash tools/stills.sh renders/remotion.mp4 && bash tools/stills.sh renders/port.mp4
   ffmpeg -v error -y -i renders/remotion.mp4 -i renders/port.mp4 -filter_complex "[0:v]scale=-2:540[a];[1:v]scale=-2:540[b];[a][b]hstack" -an renders/compare.mp4
   ```
   `stills.sh` picks its own six moments, and one can land on a scene cut (an empty frame in both). To compare chosen seconds, one pair per second:
   ```bash
   for t in 1 3 5; do
     ffmpeg -v error -y -ss $t -i renders/remotion.mp4 -ss $t -i renders/port.mp4 \
       -filter_complex "[0:v]scale=-2:540[a];[1:v]scale=-2:540[b];[a][b]hstack" -frames:v 1 -q:v 3 renders/compare-$t.jpg
   done
   ```
   Left is Remotion, right is the port. Say so in words rather than labelling the pictures: Homebrew FFmpeg builds often have no `drawtext`, so a recipe that writes labels onto frames fails there. Fix timing and eases until each pair matches in layout, colour and the moment each element arrives. A soft background gradient may show faint banding in the port (1 to 3 code values, invisible at normal viewing, the same at every `--quality`): it comes from Chrome's capture; note it and move on.
7. **List what did not carry over**: every dropped or approximated piece from step 2 and anything that still differs in the stills, in a short `PORT-NOTES.md` beside `index.html` and in your reply. From here every preset in this file works on the port.

## Preset 2: the same project, three sizes

One reel file, one `format` variable that only changes layout, one command per size.

1. `compositions/reel.html` declares the variable on its `<html>`:
   ```html
   <html data-composition-variables='[{"id":"format","type":"enum","label":"Format","default":"portrait",
     "options":[{"value":"portrait","label":"9:16"},{"value":"landscape","label":"16:9"},{"value":"square","label":"1:1"}]}]'>
   ```
2. The reel root (`id="reel-root"`) keeps `data-width="1080" data-height="1920"` (lint needs numbers there) and its CSS says `width: 100% !important; height: 100% !important;`. Without that the runtime stamps 1080x1920 inside a 16:9 host and cuts the frame.
3. The script reads `window.__hyperframes.getVariables().format` once, sets `data-format` on the root for per-size CSS, and picks a small table of numbers (phone position and scale, camera focus, iris origin). The timeline itself is shared.
   - Give the reel root its own id and select it with `document.getElementById("reel-root")`, never `document.querySelector('[data-composition-id="reel"]')`: the host slot carries the same id and comes first, so `data-format` lands on the host, every size renders with 9:16 numbers, and `check` still passes. Scope the per-size CSS to that id: `#reel-root[data-format="landscape"] { ... }`.
4. Hosts: `index.html` (1080x1920), `sizes/landscape.html` (1920x1080), `sizes/square.html` (1080x1080). Each mounts the same reel and carries its own `<audio>`:
   ```html
   <div id="el-reel" data-composition-id="reel" data-composition-src="compositions/reel.html"
     data-start="0" data-duration="18" data-track-index="1" data-width="1920" data-height="1080"
     data-variable-values='{"format":"landscape"}'></div>
   ```
   Extra hosts must sit in a subfolder (root-level copies give lint error `multiple_root_compositions`). Paths inside them resolve from the project root: `compositions/reel.html`, not `../compositions/reel.html`.
5. Render:
   ```bash
   npx -y hyperframes@0.8.75 render -o renders/reel-9x16.mp4
   npx -y hyperframes@0.8.75 render -c sizes/landscape.html -o renders/reel-16x9.mp4
   npx -y hyperframes@0.8.75 render -c sizes/square.html -o renders/reel-1x1.mp4
   ```
6. `--resolution` cannot change the aspect ratio. `lint`, `check` and `snapshot` read only `index.html`: to gate another size, copy the project to a scratch folder with that host saved as `index.html` and run `check` there, or render it and read the stills. Either way, open the snapshot or stills of every size: a wrong size passes `check` and only shows in the pictures.

A port from way 3 that is a single `index.html` gets sizes the same way: move its content into `compositions/reel.html` as a `<template>`, make `index.html` the thin host (the two skeletons in Preset 1 step 5), then follow the steps above.

## Preset 3: personalised batch (one list, many videos)

1. Make it its own project so `check` works on it: `HYPERFRAMES_SKIP_SKILLS=1 npx -y hyperframes@0.8.75 init welcome --non-interactive --resolution portrait && rm welcome/CLAUDE.md welcome/AGENTS.md`.
2. Declare every changing part on `<html data-composition-variables>` with a real default, so the preview works with nothing passed. Include a `slug` for file names:
   ```html
   <html data-composition-variables='[
     {"id":"slug","type":"string","label":"File name","default":"baitoey"},
     {"id":"name","type":"string","label":"Restaurant name","default":"ครัวใบเตย"},
     {"id":"tables","type":"number","label":"Tables","default":8,"min":1,"max":30,"step":1}]'>
   ```
   Read them once at the top of the script: `const V = window.__hyperframes.getVariables();`
3. `rows.json` is a plain array of objects keyed by variable id: `[{"slug":"baitoey","name":"ครัวใบเตย","tables":8}, ...]`. Slugs use letters, digits, `_`, `.` and `-` only.
4. Stress it before the batch: the longest name (two lines) and the largest number. What held up: one flex column where the photo card shrinks, and a name size picked from the count of visible Thai letters (tone marks and upper or lower vowels do not count), clamped (88 to 176 px there). Do not rely on `window.__hyperframes.fitTextFontSize`: it measures before the web font is loaded.
5. Gate and render:
   ```bash
   npx -y hyperframes@0.8.75 check
   npx -y hyperframes@0.8.75 render --batch rows.json --output "renders/welcome-{slug}.mp4" --strict-variables
   cat renders/manifest.json                     # per-row status, timing and variables
   npx -y hyperframes@0.8.75 render --variables '{"name":"ครัวใบเตย","tables":8}' -o one.mp4   # one row by hand
   ```
   `--strict-variables` stops the batch on an undeclared key. With `--variables`, keys you leave out fall back to the declared defaults. Use real customer names only with their permission; label sample rows as invented. Measured: 3 rows of a 7 s video in 30.1 s; 13 rows of a 6 s card in 69 to 74 s, about 1.4 MB each.

## Captions from a recording

The person gives a voice recording (a phone voice memo as `.m4a`, or `.mp3` or `.wav`) and the words they say in it. The captions follow the pauses in the speech. Nothing is transcribed, so it works the same way in Thai and in English. Tested 29 Sep on a 13 s Thai recording (three sentences in a synthetic Thai voice over a faint noise floor, not a real room): the pauses were found within 0.04 s of the true ones, `check` passed, and the 13 s video rendered in 6.7 s.

1. **Ask for the words**, one line per sentence, in the order they are spoken. This skill does not transcribe: if the person has no script, ask them to type what they said. English lines they did not write are your translation: flag them.
2. **Scaffold** a new folder (see "Scaffolding with `init`") and copy the recording into it as `assets/voice.m4a` (keep its own extension). Its length: `ffprobe -v error -show_entries format=duration -of csv=p=0 assets/voice.m4a`.
3. **Find where each sentence is spoken:**
   ```bash
   ffmpeg -hide_banner -nostats -i assets/voice.m4a -af silencedetect=noise=-35dB:d=0.35 -f null - 2>&1 | grep -o "silence_[a-z]*: [0-9.]*"
   ```
   Speech runs from each `silence_end` to the next `silence_start` (from 0 when the file does not open on silence, to the end when it does not end on one). There must be exactly one run per line. More runs than lines: a pause inside a sentence, so raise `d` (0.5, then 0.7). Fewer: two sentences said without a pause, so lower `d` (0.25), or in a noisy room raise `noise` toward `-30dB`. Still no match: show the person the runs next to the lines and ask. Never guess a time.
4. **One caption clip per line**: `data-start` = its run's start minus 0.1 s, `data-duration` up to the next caption's start (the last one to the end of the recording), in the bilingual order and the caption style of the SV defaults (Preset 1 step 6). Keep each caption's markup to `<span>` and `<br />` inside the clip, or lint warns `nested_structure_needs_subcomposition`. Load the Thai face as local woff2 with `@font-face` (lint errors `font_family_without_font_face` otherwise).
5. **The recording as one clip** on the root, whose `data-duration` is the recording's length:
   ```html
   <audio id="voice" class="clip" src="assets/voice.m4a" data-start="0" data-duration="13" data-track-index="2" data-volume="1"></audio>
   ```
6. `lint`, `check`, render. **Check the timing:** run the same `silencedetect` line on the MP4; its runs must match the recording's (in the test they matched to the millisecond). Then look at one still from the middle of each run: the caption on screen must be the sentence being said.

## Slides you present from the file

A short deck (a pitch, a team meeting, a talk) as one file, presented from the laptop with `present`, which serves the file with back and next controls and a second window for the audience. The deliverable is the live deck, not an MP4. Tested 29 Sep on a three slide 16:9 deck with Thai titles: `check` passed and the presenter moved 1/3, 2/3, 3/3 with the arrow keys.

1. **Scaffold** a new folder with `--resolution landscape`. Each slide is one timed clip, laid end to end (3 s each is plenty: the presenter holds on each slide until the next key press), with its own id (`s1`, `s2` ...).
2. **The slide list**, as its own script block in `index.html`, after the root:
   ```html
   <script type="application/hyperframes-slideshow+json">
     {"slides":[{"sceneId":"s1","startTime":0,"endTime":3},{"sceneId":"s2","startTime":3,"endTime":6},{"sceneId":"s3","startTime":6,"endTime":9}]}
   </script>
   ```
   `sceneId` is the slide's id, `startTime` and `endTime` its seconds. Slides must not overlap (`lint` checks the list).
3. **Hide slides on the timeline.** The presenter does not hide clips by their times, so every slide would show at once. `gsap.set` every slide after the first to `opacity: 0` before the timeline, then at each boundary one 0.05 s `tl.to` takes the old slide to 0 and one takes the next to 1. Begin the script with `window.__timelines = window.__timelines || {};`: in the presenter the page has no timeline map yet, and without that line it throws and never moves.
4. `check`, then start it in the background: `npx -y hyperframes@0.8.75 present` opens the browser and prints a `Present` line with the address, `http://localhost:3004` by default (add `--no-open` to only print it). Hand over that address. The arrow keys or the on-screen arrows move one slide; `P` opens the audience window for a second screen. Stop it with Ctrl+C. The same file also renders to an MP4 with `render` (tested: 9 s, one slide after another) if they want a video as well.

## Preset 4 (optional): voiceover

Only this was verified. The captioned video without a voice is the main deliverable and stands on its own.

- Engine: macOS `say` with a Thai system voice. List them with `say -v '?' | grep -i th`. Thai voices depend on the machine (the test Mac had only Kanya). It sounds synthetic; a person must listen before it is shown, and it is labelled "macOS system voice (Kanya)".
- `hyperframes tts` (Kokoro) has no Thai (`--lang` is en-us, en-gb, es, fr-fr, hi, it, pt-br, ja, zh). Windows has no `say`; untested.
- Method: speak the same words as the captions, one file per line (`say -v Kanya -r 185 -o line1.aiff "..."`), place each line on its caption time with FFmpeg `adelay`, pad to the video length, `loudnorm=I=-16:TP=-1.5`, write 48 kHz stereo WAV.
- Mix in a separate host (for example `sizes/showcase-vo.html`) with two `<audio>` elements: the bed at `data-volume="0.45"`, the voice at `1`. Render it with `-c`.
- Check it: a transcription of the final MP4 should read back the script. Whisper large-v3-turbo did for Kanya. `hyperframes transcribe` was not tested on Thai. Without Whisper on the machine, a person listens to the whole voice against the script; that listen is required either way.

## Composing

- **Shape.** One root element with `data-composition-id`, `data-width`, `data-height`, `data-start`, `data-duration`. Timed children carry `class="clip"`, `data-start`, `data-duration`, `data-track-index`. Track index is scheduling, not stacking (use `z-index`), and two clips on one track cannot overlap in time. Duration is authoritative. Media plays through its own `<audio>` element; video elements stay muted.
- **Still frame first.** Write the CSS for the moment each scene has fully arrived, get that frame right as static markup, then animate from offscreen or invisible into it. Scene containers fill their parent; children use flex and gap. Absolute positioning is for decoration.
- **One paused timeline per composition,** built synchronously and registered once: `window.__timelines["reel"] = tl;`. A sub-composition's timeline cannot touch the host, so everything that moves lives in the reel file.
- **Directed, not generated.** First movement at 0.1 to 0.3 s, never 0. Mix eases per scene (back, expo, power, sine). Every element gets its own entrance. Transitions do the exit work; fade-outs only on the last beat.
- **Never put `back` or `elastic` eases on `filter` or `opacity`.** The overshoot pushes `blur()` below zero, which is invalid CSS: the element stays blurred through its entrance and a frame can depend on the previous seek. Split the tween: `back.out` on x or y, `power2.out` on opacity plus blur, same start, both as `tl.to` from a `gsap.set` start (next point).
- **Starting states: `gsap.set`, then `tl.to`.** Before building the timeline, set where each animated element starts with `gsap.set(...)` (outside the timeline), then move it with `tl.to(...)`. The CSS still describes the arrived frame. Two things this avoids, both lint warnings in 0.8.75: a hiding `tl.set(..., 0)` inside the timeline is not applied while the playhead sits exactly at 0, so frame 0 shows the element (`gsap_timeline_set_initial_hide`); and two `tl.fromTo` on one element, which the split tween above needs, give `gsap_repeated_fromto_without_baseline`. One `tl.fromTo` per element is fine. The Preset 1 step 5 skeleton shows the form.
- **Video type sizes.** Headlines 60 px and up, body 20 px and up, labels 16 px and up (at 1080 wide, go larger). Do not force `<br>` into body copy; constrain the width. Deliberate display lines are the exception.

## Rules that keep a render reproducible

Many Chrome workers seek to exact frames in parallel. The 0.8.75 reel rendered with 1 and with 5 workers matched (PSNR 50 dB).

1. No `Math.random()` and no `Date.now()`. Use a seeded generator (mulberry32 with a fixed seed) for scatter and grain.
2. No infinite repeats: compute the count from the duration.
3. No `async`, `setTimeout` or promises around timeline building.
4. Animate visual properties only: transforms, opacity, colour, filter, custom properties. Never `display`, `visibility` or `letterSpacing`, and never play, pause or seek media yourself.
5. Never tween the same property of the same element from two places at once. Start a follow-on tween 0.02 to 0.05 s after the previous one ends.
6. No live iframes in the final video (see Preset 1, step 3).

## Checks before and after the render

```bash
npx -y hyperframes@0.8.75 lint                                    # structure, 0 errors
npx -y hyperframes@0.8.75 check                                   # lint + runtime + layout + motion + WCAG contrast
npx -y hyperframes@0.8.75 snapshot --at 1.0,3.5,6.9,12.0,17.0 --no-end
```

`validate` and `inspect` still run in 0.8.75 but are deprecated in favour of `check`. Read the findings, do not skim for pass or fail. Read the Contrast line too: `0/0 text checks` means nothing was measured (see "Their brand leads"), not that contrast passed. `snapshot` prints `GEMINI_API_KEY not set, skipping` for its optional picture description: harmless, the PNGs are still written. Expected `info` findings from these methods, leave them alone: `container_overflow` on a `.mask` while its line waits below it, `panel_out_of_canvas` while the phone rises from off canvas, `text_occluded` on text under a closed iris. Overflow means: more room, smaller type, a real `max-width`, or copy too long for the beat. Fix contrast by pushing an existing brand colour lighter or darker, never by inventing one. `composition_file_too_large` on the one-file reel is advisory and acceptable. After the render: `ffprobe` for size, duration and an audio stream (when the video has sound), then `tools/stills.sh` and actually open the contact sheet.

## When it fails

| Symptom | Cause and fix |
| --- | --- |
| Render dies or produces nothing | `doctor`: usually FFmpeg, or Chrome (`browser ensure --force`) |
| `doctor` shows a cross on Version (`0.8.75 -> 0.8.x available`) | Expected with the pin. Do not upgrade; pre-flight has passed |
| `init` prints "Restart your AI agent" or "Linked skills into N other agent directories" | It ran without `HYPERFRAMES_SKIP_SKILLS=1`. Do not restart; this skill still decides. Use the prefix next time |
| Render or check fails, or frames come out blank, with no network | GSAP loads from `cdn.jsdelivr.net`: allow network access ("Network" in Pre-flight) |
| Every phone shot has a cookie banner or chat button on it | `HIDE="<selectors>"` before `node tools/phone-shots.mjs` (Preset 1 step 3). Never click Accept |
| A card is blank at the seam between two stitched shots | Its scroll reveal had not fired: `PRESCROLL=1` |
| A dark band across every seam of the strip | `navHeight` left out the nav's drop shadow: measure where the content is clean |
| Render much slower and file much bigger than the reference | Heavy effects (`backdrop-filter`, `mask-image`, SVG grain, 3D): normal. Make the share copy |
| Blank frames | Timeline not registered under the composition id, or the root has no id |
| A clip never shows | Two clips on one track overlap in time |
| Preview right, file wrong | Something non-deterministic, or a tween outlives its clip |
| Frame cut off in 16:9 or 1:1 | Reel root missing `width: 100% !important; height: 100% !important` |
| All sizes look like 9:16 (phone cut off, frame unbalanced), `check` passes | `data-format` set on the host slot: select the root with `getElementById("reel-root")` |
| First `check`: dozens of `content_overlap` and contrast errors | Beats are not timed clips, so every scene's text exists at every time: give each beat `class="clip"` and its own `data-start`/`data-duration` |
| Card or pill stays blurred through its entrance | `back` or `elastic` ease on `filter`: split the tween |
| Edit fails "substring not found" after the preview started | Studio stamped `data-hf-id` and normalised attributes: re-read the file |
| An MP4 nobody asked for in `renders/` (`<project>_<timestamp>.mp4`) | The Studio rendered on open: ignore or delete it |
| `[WARN] ... may exceed this process's V8 heap` | Only a warning. If the render then dies with "JavaScript heap out of memory": `--workers 2`, or `NODE_OPTIONS=--max-old-space-size=8192` |
| Logo soft or blurry | Small raster logo blown up: fetch the original, use it at 1.2x at most, name as live text beside it |
| lint `multiple_root_compositions` | Extra size hosts at the root: move them to `sizes/` |
| lint `root_missing_dimensions` | Root lost its numeric `data-width`/`data-height` |
| lint `gsap_non_transform_motion` | Tweened `letterSpacing` or layout: use `yPercent` and `filter: blur()` |
| lint `overlapping_gsap_tweens` | Next tween starts exactly as the last ends: move it 0.02 to 0.05 s |
| lint `gsap_repeated_fromto_without_baseline` | Two `tl.fromTo` on one element (often the split tween): `gsap.set` the start once before the timeline, then `tl.to` for each half ("Composing", starting states) |
| lint `gsap_timeline_set_initial_hide` | A `tl.set(..., 0)` that hides: frame 0 shows the element. Move it to `gsap.set(...)` before the timeline, or write the hidden state in CSS |
| lint `nested_structure_needs_subcomposition`, one per scene | A one-file port (way 3): expected and harmless. To clear it, move the scenes into `compositions/reel.html` with a thin host |
| lint `duplicate_media_discovery_risk` | One image used in several places: crop each use into its own file |
| check `content_overlap` on rotated cards, or on text under an iris | `data-layout-allow-overlap` on the exact element the error names (usually the innermost text span); it is not inherited from a wrapper or a `.mask` row |
| check says `Contrast 0/0 text checks pass` | Nothing was measured: text colours in `oklch()` (or `lab()`, `lch()`, `color()`). Judge contrast on the snapshots, or convert those tokens to the same colour in hex |
| check `text_occluded` as an error before an entrance | Word waiting below its mask: enter with opacity plus x instead |
| Thai word clipped mid-entrance | `scale` inside an `overflow: hidden` mask: use `yPercent` plus blur |
| Hard-edged empty circle in a transition | `clip-path: circle()` iris: use a `mask-image` radial gradient, start the logo earlier |
| "Not inlining ... exceeds the 2 MB inline limit" | PNG screens: use JPEG quality 92 |
| Caption unreadable over busy UI | Glass too thin: about 84% plus backdrop blur |
| `node tools/phone-shots.mjs`: "Cannot find module" | The helper was never written: write it from "Helper scripts" first |
| Way 2: the local app will not start | Missing keys, database or login: do not invent them, rebuild the screens from the code (Way 2, step 7) |
| Way 3: the port drifts later and later against the Remotion render | A frame number was not divided by fps, or a `<Series>` length was not added up |
| Way 3: motion lands right but feels different | A `spring()` mapped to the wrong ease or length: compare stills and adjust |
| Way 3: the port runs at 30 fps, the source at 24, 25 or 60 | No `data-fps` on the root: add the source's `fps` (Way 3, step 3) |
| Captions from a recording: more or fewer speech runs than lines | Change `d` or `noise` in the `silencedetect` line ("Captions from a recording", step 3); still no match: ask, never guess |
| `present`: every slide shows at once | The presenter does not hide clips by time: hide each slide on the timeline ("Slides you present from the file", step 3) |
| `present`: the page never moves, console says it cannot set `main` | Begin the script with `window.__timelines = window.__timelines \|\| {};` |

## Editing something that already exists

Read the file first. Take the real hex values, eases and timings from the source, change only what was asked, and leave every unrelated clip's timing alone. The composition is its own specification. Measured on a 12 s reel: "Make my web address bigger on the last frame" became one changed tween (the address pill's entrance ends 1.5x larger, capped at 900 px wide, growing from its top centre, a transform rather than a bigger font so the centred column above it does not move) and a new MP4 in 26 s.

## Helper scripts

Three small scripts, SV Academy's own, MIT. They live in this file so one file is all anyone needs. **When a step needs one, write the block below to `tools/<name>` in the project first**, byte for byte, then run it. (The same scripts sit in the repo's `tools/` folder only as a mirror for old links; this file is the source of truth.) On Windows, run the two `.sh` scripts in Git Bash or WSL, or ask the agent to port them (untested).

### tools/phone-shots.mjs

Real phone screenshots of a live site (or a local dev server), as used in Preset 1 step 3 and Way 2 step 7. When you need this, write it to `tools/phone-shots.mjs` in the project first, then run it with `node`.

```js
// phone-shots.mjs: real phone screenshots of a live site, no extra installs.
// Needs only Node 22+ and the Chrome that HyperFrames already downloaded.
//
//   node tools/phone-shots.mjs <url> <outDir> <name>=<scrollY or #selector> ...
//   node tools/phone-shots.mjs https://sv-academy.org/ assets/phone hero=0 flow=#flow
//   name=<pixels>   scroll that far down, then shoot the phone screen
//   name=#id        scroll to that section, then shoot
//   name=@selector  shoot one element (a logo) on a transparent background, 8x (sharp for text or SVG; a raster logo only gets upscaled, check its natural size)
//
// Each shot is 390x844 CSS px (an iPhone-sized viewport) at 3x = 1170x2532 JPEG.
// Element shots (@selector) are transparent PNG.
//
// Optional settings, set before the command:
//   SETTLE_MS=2600          wait longer after each scroll (cards caught mid-animation)
//   HIDE=".cookie,.chat"    hide fixed overlays (cookie banner, chat button) with CSS.
//                           It never clicks Accept and never stores consent.
//   PRESCROLL=1             walk the whole page once before shooting, so every
//                           scroll reveal has fired (blank cards at a tile seam)
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
  if (process.env.HIDE) {
    // Hide overlays with CSS only: nothing is clicked, no consent is given or stored.
    await send("Runtime.evaluate", { expression: `(() => { const st = document.createElement("style"); st.id = "__hide"; st.textContent = ${JSON.stringify(process.env.HIDE)} + "{display:none!important}"; document.head.appendChild(st); })()` });
  }
  if (process.env.PRESCROLL) {
    // Walk the whole page once so every scroll reveal fires, then go back to the top.
    const total = (await send("Runtime.evaluate", { expression: "document.documentElement.scrollHeight", returnByValue: true })).result.value;
    for (let y = 0; y <= total; y += 200) {
      await send("Runtime.evaluate", { expression: `window.scrollTo(0, ${y})` });
      await sleep(60);
    }
    await send("Runtime.evaluate", { expression: "window.scrollTo(0, 0)" });
    await sleep(SETTLE_MS);
  }
  mkdirSync(outDir, { recursive: true });
  for (const spec of specs) {
    const eq = spec.indexOf("="); // split at the first = only: a selector may hold one (img[alt="Logo"])
    const name = eq < 0 ? spec : spec.slice(0, eq);
    const where = eq < 0 ? "0" : spec.slice(eq + 1);
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
```

### tools/stills.sh

Six evenly spaced stills plus a contact sheet from any MP4, for looking before showing. When you need this, write it to `tools/stills.sh` in the project first, then run it with `bash`.

```bash
#!/usr/bin/env bash
# stills.sh VIDEO [OUT_DIR] : six evenly spaced stills (JPEG) plus one contact sheet, for eyeballing a render.
set -euo pipefail
V="$1"; OUT="${2:-renders/stills}"; mkdir -p "$OUT"
N="$(basename "${V%.*}")"
D="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$V")"
i=0
for f in 0.08 0.25 0.42 0.58 0.75 0.92; do
  i=$((i+1)); t="$(awk -v d="$D" -v f="$f" 'BEGIN{printf "%.3f", d*f}')"
  ffmpeg -v error -y -ss "$t" -i "$V" -frames:v 1 -q:v 3 "$OUT/$N-$i.jpg"
done
ffmpeg -v error -y -i "$OUT/$N-1.jpg" -i "$OUT/$N-2.jpg" -i "$OUT/$N-3.jpg" -i "$OUT/$N-4.jpg" -i "$OUT/$N-5.jpg" -i "$OUT/$N-6.jpg" \
  -filter_complex "[0]scale=-2:540[a];[1]scale=-2:540[b];[2]scale=-2:540[c];[3]scale=-2:540[d];[4]scale=-2:540[e];[5]scale=-2:540[f];[a][b][c][d][e][f]hstack=6" -q:v 3 "$OUT/$N-sheet.jpg"
echo "$OUT/$N-[1-6].jpg + $OUT/$N-sheet.jpg"
```

### tools/make-sound.sh

An 18 s music bed synthesised with FFmpeg only: no samples, no downloads, no licences. It is the template from the 18 s reference reel: move the hit times to your own beats. When you need this, write it to `tools/make-sound.sh` in the project first, then run it with `bash`.

```bash
#!/usr/bin/env bash
# make-sound.sh: an 18 second warm music bed with hits on the reel's beats.
# Pure FFmpeg synthesis (layered sine waves with envelopes, plus filtered noise).
# No samples, no downloads, no licences to worry about.
#
#   bash tools/make-sound.sh                 -> assets/audio/bed.wav
#   bash tools/make-sound.sh out.wav
#
# TEMPLATE from the SV Motion 18 s reference reel. The hit times below are that reel's
# beats (hook 0 to 3.0, logo 3.25, phone 4.9, callouts 6.2 / 8.4 / 10.8, tagline
# slams 12.8 to 13.7, close sting 15.6). Move them to your own beat list, and change
# DUR and the final afade start if your video is not 18 seconds long.
set -euo pipefail
OUT="${1:-assets/audio/bed.wav}"
mkdir -p "$(dirname "$OUT")"
DUR=18
TMP="$(mktemp -d)"

# pluck T0 FREQ DECAY AMP : marimba-like hit (fundamental + 4x partial, exponential decay)
pluck() { echo "$4*(sin(2*PI*$2*t)+0.30*sin(2*PI*$2*4*t))*exp(-$3*(t-$1))*gte(t,$1)"; }
# bell T0 FREQ DECAY AMP : inharmonic bell (1, 2.76, 5.4 partials)
bell() { echo "$4*(sin(2*PI*$2*t)+0.45*sin(2*PI*$2*2.76*t)*exp(-2*(t-$1))+0.2*sin(2*PI*$2*5.4*t)*exp(-4*(t-$1)))*exp(-$3*(t-$1))*gte(t,$1)"; }
# thump T0 FREQ AMP : low body hit with a small pitch drop
thump() { echo "$3*sin(2*PI*($2*(t-$1)-18*(t-$1)*(t-$1)))*exp(-11*(t-$1))*gte(t,$1)"; }
# env A B C D : 0 before A, ramps up A..B, holds, ramps down C..D
env() { echo "(clip((t-$1)/($2-$1),0,1)*clip(($4-t)/($4-$3),0,1))"; }

# Hook pad: tense A minor colour, slow tremolo (0 to 3.5 s)
PAD1="$(env 0.0 1.0 3.1 3.7)*(0.9+0.1*sin(2*PI*2.5*t))*(0.060*sin(2*PI*110*t)+0.045*sin(2*PI*164.81*t)+0.035*sin(2*PI*261.63*t)+0.020*sin(2*PI*220.9*t))"
# Main pad: warm A major (3.3 to 12.8 s)
PAD2="$(env 3.3 4.4 12.2 12.9)*(0.050*sin(2*PI*110*t)+0.040*sin(2*PI*164.81*t)+0.034*sin(2*PI*220*t)+0.028*sin(2*PI*277.18*t)+0.022*sin(2*PI*329.63*t)+0.010*sin(2*PI*440.7*t))"
# Tagline pad: D major lift (12.5 to 15.8 s)
PAD3="$(env 12.5 13.2 15.2 15.9)*(0.050*sin(2*PI*146.83*t)+0.040*sin(2*PI*220*t)+0.032*sin(2*PI*293.66*t)+0.026*sin(2*PI*369.99*t)+0.016*sin(2*PI*440*t))"
# Close pad: A major, fades to silence by 18 s
PAD4="$(env 15.4 16.2 17.0 18.0)*(0.050*sin(2*PI*110*t)+0.040*sin(2*PI*164.81*t)+0.032*sin(2*PI*277.18*t)+0.026*sin(2*PI*329.63*t)+0.018*sin(2*PI*440*t))"
# Hook heartbeat
BEAT="$(thump 0.20 62 0.42)+$(thump 0.95 62 0.36)+$(thump 1.70 62 0.40)+$(thump 2.45 62 0.34)"
# Logo chime, callout plucks, tagline slams, closing sting
HITS="$(bell 3.25 880 2.2 0.10)+$(bell 3.25 1318.5 2.6 0.05)"
HITS="$HITS+$(pluck 6.20 659.26 6 0.11)+$(pluck 8.40 880 6 0.11)+$(pluck 10.78 1108.73 6 0.10)"
HITS="$HITS+$(thump 12.80 98 0.40)+$(thump 13.10 110 0.38)+$(thump 13.40 123.5 0.38)+$(thump 13.70 146.8 0.42)"
HITS="$HITS+$(bell 14.05 587.33 1.6 0.07)+$(bell 14.05 880 1.8 0.05)"
HITS="$HITS+$(thump 15.60 55 0.50)+$(bell 15.62 440 0.9 0.09)+$(bell 15.62 554.37 1.0 0.07)+$(bell 15.62 659.26 1.1 0.06)+$(bell 15.64 880 1.3 0.05)"

L="$PAD1+$PAD2+$PAD3+$PAD4+$BEAT+$HITS"
# Right channel: same, with pads detuned a hair for width
R="$(echo "$L" | sed -e 's/2\*PI\*110\*t/2*PI*110.4*t/g' -e 's/2\*PI\*164.81\*t/2*PI*165.3*t/g')"

ffmpeg -v error -y -f lavfi -i "aevalsrc=exprs='$L|$R':s=48000:d=$DUR" -c:a pcm_s16le "$TMP/tones.wav"

# Whooshes on the scene changes: pink noise through a band-pass, gated by an envelope
W="0.9*$(env 2.80 3.10 3.15 3.60)+0.6*$(env 4.70 5.00 5.10 5.60)+0.8*$(env 12.10 12.45 12.50 12.95)+0.9*$(env 15.05 15.40 15.45 15.95)"
ffmpeg -v error -y -f lavfi -i "anoisesrc=color=pink:seed=7:amplitude=0.5:d=$DUR:r=48000" \
  -af "highpass=f=500,lowpass=f=4200,asetnsamples=n=256,volume='0.55*($W)':eval=frame,pan=stereo|c0=c0|c1=c0" \
  -c:a pcm_s16le "$TMP/air.wav"

# Mix, gentle glue, normalise to a social-video loudness, fade the tail
ffmpeg -v error -y -i "$TMP/tones.wav" -i "$TMP/air.wav" \
  -filter_complex "[0][1]amix=inputs=2:normalize=0,acompressor=threshold=-18dB:ratio=2:attack=20:release=250,loudnorm=I=-16:TP=-1.5:LRA=11,afade=t=out:st=17.4:d=0.6,aresample=48000" \
  -ac 2 -ar 48000 -c:a pcm_s16le "$OUT"
rm -rf "$TMP"
echo "wrote $OUT"
```

## Codex and other agents

This skill is plain markdown in one file. An agent without skill support can be told:

```text
Read https://raw.githubusercontent.com/sva-admin/sv-motion/main/SKILL.md and follow it for everything we do in this session.
```

Nothing else needs to be fetched: the helper scripts are inside this file, under "Helper scripts". Three notes for those agents:

- Give the agent network access (see "Network" under Pre-flight); a sandbox with the network off cannot run `npx`, `capture`, the font download or the render.
- Slash commands such as `/brag` and trigger phrases are Claude Code skill mechanics. Other agents ignore them, which is fine: the instruction above is the trigger.
- The `CLAUDE.md` and `AGENTS.md` that `init` and `capture` write point to other workflows. Delete the ones `init` writes, as in "Scaffolding with `init`", and ignore the capture's.

## License

SV Motion is SV Academy's own skill, written in our own words and licensed MIT. It copies no code or documentation from anyone. The engine it drives is a separate open source tool, run through `npx`; its own `--help` is the authority on flags.

Learn it free: <https://loop.sv-academy.org/articles/video-from-a-text-file>

More from Silicon Valley Academy: <https://github.com/sva-admin/claude-skills> and <https://sv-academy.org>
