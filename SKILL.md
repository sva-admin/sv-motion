---
name: sv-motion
description: SV Academy's working method for HyperFrames by HeyGen. The video is one HTML text file that an agent writes and a person can read, rendered to MP4 on your own machine. Use it to turn a live website into an agency-grade launch reel, to make the same video in 9:16, 16:9 and 1:1 from one file, and to render personalised videos from a list. Trigger on "SV Motion", "sv-motion", "launch reel", "launch video from my site", "turn my website into a video", "hyperframes", "video from a text file", "same video in three sizes", "personalised videos from a list", "render a batch", "make a video from this", "turn this text into a video", "render this as an MP4", "video from my script", "animated title card", "add captions to this audio", "re-render the video with the new numbers", "vertical clip for social".
---

# SV Motion. The video is a text file.

SV Academy's working method for **HyperFrames by HeyGen**. Layout is markup, timing is attributes, motion is a script. Nothing is baked until the render, so changing a headline costs a re-render, not a re-shoot.

HeyGen built and maintains the engine, the CLI and the runtime: <https://github.com/heygen-com/hyperframes>. This file is an independent SV Academy usage guide, MIT licensed, with none of their code or documentation. For flags, their CLI is the authority: `npx -y hyperframes@0.8.75 docs` and `<command> --help`.

Free lesson, step by step: <https://loop.sv-academy.org/articles/video-from-a-text-file>

If someone asks about Remotion: "Remotion is video in React for developers; HyperFrames is one HTML file your agent writes and you can read."

## Pin the version: 0.8.75

Run every command as `npx -y hyperframes@0.8.75 <command>`. Never bare `npx hyperframes`, never `@latest`. A class of 13 on one Wi-Fi must get identical behaviour, and HyperFrames ships often. Every method below was run against 0.8.75. Upgrade on purpose: change the pin, re-run the checks on a known project, then roll it out. `init` already pins the project's `npm run check` and `npm run render` scripts to 0.8.75.

The HyperFrames skills that `init` installs may describe a newer CLI in places. When they disagree with this file, trust `npx -y hyperframes@0.8.75 <command> --help`. Also in 0.8.75 but outside these presets: `present` (serves a slideshow deck in presenter mode), `render --format webm` (transparent overlay), `render --variables-file <file.json>`.

## Pre-flight: run this first

```bash
node --version                        # v22 or newer
ffmpeg -version                       # any recent build
npx -y hyperframes@0.8.75 doctor
```

Must pass in `doctor`: Version 0.8.75, Node.js, FFmpeg, FFprobe, Chrome, Memory, Disk. Crosses on whisper-cpp, TTS (Kokoro), BGM (MusicGen) and Docker are optional and fine, so "Some checks failed" with only those is normal.

| Missing | macOS | Windows (from docs, not tested on Windows) |
| --- | --- | --- |
| Node 22+ | `brew install node`, or the LTS installer from nodejs.org | `winget install OpenJS.NodeJS.LTS` |
| FFmpeg, FFprobe | `brew install ffmpeg` (no Homebrew: install it from brew.sh first) | `winget install --id Gyan.FFmpeg -e`, or the build from ffmpeg.org on PATH |
| Chrome | `npx -y hyperframes@0.8.75 browser ensure` (add `--force` if a download broke) | same |
| Memory, Disk | close apps and tabs, free a few GB | same |

Before class, at home: run `doctor` and `browser ensure` once, so 13 people on one Wi-Fi only fetch the site. After any install, open a new terminal (or restart the agent) so the command is found. The user types every password, never the agent. Quote every path that has a space in it. Windows PowerShell (untested): `curl.exe`, not `curl` (an alias for Invoke-WebRequest there); set a variable first (`$env:SETTLE_MS=2600`); copy folders with `Copy-Item -Recurse`; run `tools/*.sh` in Git Bash or WSL. Renders send anonymous telemetry by default (per the CLI docs); `npx -y hyperframes@0.8.75 telemetry disable` turns it off. These presets never run `publish`, `cloud`, `lambda`, `cloudrun`, `auth` or `feedback`.

## Classroom mode

1. Show the beat list first: plain sentences, seconds on each. Then carry on, unless the user asked to approve it.
2. Run `check` until it passes.
3. Give a scrubbable preview: `npx -y hyperframes@0.8.75 preview --background` prints `Studio http://localhost:3002/#project/<folder>`. Hand over that URL, not a file path. Stop it with `preview --stop`.
   - Starting the preview rewrites your HTML: it stamps `data-hf-id` on every element and normalises attributes (`data-layout-allow-overlap` becomes `data-layout-allow-overlap=""`, `&#183;` becomes `·`). Harmless, but re-read the file before the next edit and never match on text written before the preview. `check` does not change files.
   - Opening the Studio can start a render by itself (software GPU, 37.5 s on an M3 Max) that writes `renders/<project>_<timestamp>.mp4` and a `.meta.json`. It is not the user's video: ignore or delete it. On slow laptops close the Studio tab or run `preview --stop` before your own `render`.
4. Iterate with the preview and `snapshot`, not full renders. `render --quality draft` helps on slow laptops only; on an M3 Max it took 14 to 19 s, no faster than the final.
5. Small machine: `render --workers 2` (each worker is a Chrome process, about 256 MB). At 8 GB RAM or less, 0.8.75 drops to one worker by itself (`--low-memory-mode`). `--workers 1` gives the same frames, just slower (28.5 s against 14.1 s here).
6. Render the final at the default quality (`looks`, CRF 16; the log prints `standard`). No `--quality` flag.
7. Show six stills from the MP4 (`tools/stills.sh`) and say where the file is.
8. A share copy for LINE on mobile data (the 18 s master is about 20 MB): `ffmpeg -i renders/reel-9x16.mp4 -c:v libx264 -crf 24 -preset medium -pix_fmt yuv420p -movflags +faststart -c:a copy renders/reel-9x16-share.mp4` (20 MB to 4.7 MB in 3 s, PSNR 46 dB against the master).

Reference timings (M3 Max, 0.8.75): 18 s 1080x1920 reel renders in 14.3 s, `check` 12.7 to 20 s, 5 phone screens 25 s, a 3-row batch of 7 s videos 30.1 s. A fresh agent reading this skill cold reached the Studio preview in 12.6 min and the first MP4 in 17.1 min; "make it 16:9" then took 2.7 min. On an 8 GB laptop expect `check` at 1 to 2 min and a render of several minutes.

## SV defaults

- **Their brand leads.** The owner's colours, fonts, wordmark and words, never SV Academy's. Copy hex values literally from the capture.
- **Real assets only.** Real phone screenshots of the live site, the site's own photos, the site's own words (`visible-text.txt`, word for word for any claim). No stock footage, no invented screenshots, prices, numbers or reviews. Site photos are often about 720 px wide: use them blurred as backgrounds or near native size in a frame, never blown up full screen. Invented sample data (batch rows) is called invented.
- **The site wins.** If the user's description and the live site disagree (a "pet profile app" whose site is a grooming spa), follow the site's own words, say so, and ask whether a different page or app should be filmed.
- **Adult, editorial, plain.** These are business owners. Confident type, restrained motion, no emoji, stickers, cartoon bounce or cute mascots.
- **Thai typography.**
  - Use the site's Thai font from the capture, shipped as local woff2 in `fonts/`.
  - No Thai face in `fonts-manifest.json` means the site's Thai shows in the phone's system font. Ship a free Google Thai face that matches the site's sans (Noto Sans Thai passed check, snapshot and render) as local woff2, and tell the user. The Google Fonts route, tested 25 Sep:
    ```bash
    UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36'
    curl -sSL -A "$UA" "https://fonts.googleapis.com/css2?family=Noto+Sans+Thai:wght@400;600;700" -o thai.css
    # the url(...) under the /* thai */ comment is one variable woff2 for weights 100 to 900
    curl -sSL -o fonts/noto-sans-thai.woff2 "<that url>"
    ```
  - Generous line height. For masked reveals give each `.mask` `padding: 0.26em 0.06em 0.16em` and the matching negative margin, so tone marks (ไม้ตรี on โต๊ะ, ไม้จัตวา on ก๋วยเตี๋ยว) and lower vowels are never cut by `overflow: hidden`.
  - No `letter-spacing` and no `text-transform` on Thai. Thai has no spaces between words, so set display lines by hand, one element per line, split at phrase boundaries.
  - Check the marks on a close crop of one line element (for example the Thai hook line `#h4`): `npx -y hyperframes@0.8.75 snapshot --at <seconds> --zoom "#<line-id>" --no-end -o snapshots/marks`. Zoom on a full-frame layer gives the whole frame at 3x (3240x5760), not a crop.
  - Check the captured subsets. A Thai subset may have no Latin or digits (OrderDi's upright Trirong had none), so set English and digits in a face that covers them. If a weight the site uses is missing from the capture, tell the user and fetch it by the Google Fonts route above, or use the nearest captured weight.
- **Bilingual order.** Thai line first, English second, unless the site is English first. Hook, captions and tagline all follow this order. When the site has no wording in one language for a line (an English-first site often has only a motto in Thai), translate the site's own words faithfully, tell the user which lines are your translation, and ask the owner to approve them before the video is shared.
- **Last frame.** Wordmark, the site's own offer line, and the live address as plain text (for example `order-di-home.apps.sv-academy.org`), on screen for at least two seconds. In 9:16 size the group to hold the tall frame, not a small cluster between empty bands.
- **Tag.** A small, quiet "Made with SV Motion" on the last frame. The user may remove it.

## Preset 1: launch reel from a live site, 9:16

Keep the capture beside the project, not inside it (the capture ships its own CLAUDE.md that points to a different workflow; ignore it, this skill decides). `init` also writes a `CLAUDE.md` and `AGENTS.md` into `launch-reel/` that route to other workflows (`/hyperframes`, `/product-launch-video`) with unpinned `npx hyperframes`, and prints "Restart your AI agent". This skill still decides: keep the @0.8.75 pin and do not restart the session.

1. **Scaffold and capture**, from a work folder:
   ```bash
   npx -y hyperframes@0.8.75 init launch-reel --non-interactive --resolution portrait
   npx -y hyperframes@0.8.75 capture https://<name>.apps.sv-academy.org/ -o capture --skip-vision
   ```
2. **Brand from the capture.** Read `capture/extracted/tokens.json` (colours, fonts), `design-styles.json` (type scale, radii, shadows), `fonts-manifest.json` and `visible-text.txt`, and look at `capture/screenshots/contact-sheet-1.jpg` and `capture/assets/contact-sheet.jpg`. Copy the fonts and photos you use into `launch-reel/fonts/` and `launch-reel/assets/`: paths resolve from the project root. Capture screenshots are desktop 1920x1080 only (`capture` has no viewport option), so they are brand data, not phone screens.
   - **Logo.** Find it in `capture/extracted/page.html` and check its natural size. A capture line like `Dropped: 1 (1 size-floor)` means a small image was skipped, often the logo. If it is a small raster (Paw & Play's was a 300x85 PNG), fetch the original (`curl -sSL -o assets/brand/logo.png "<src>"`; `-L` follows the redirect to storage), use it at no more than about 1.2x, and let the brand name, set as live text in the site's font beside it, carry the size, the way the site's header pairs them. An `@selector` shot only upscales a raster logo into a blur; it is sharp for text or SVG wordmarks.
3. **Phone screens.** Copy all three tools from this skill into `launch-reel/tools/`: `phone-shots.mjs`, `stills.sh`, `make-sound.sh` (raw: `https://raw.githubusercontent.com/sva-admin/sv-motion/main/tools/<name>`). `phone-shots.mjs` needs only Node 22 and the Chrome HyperFrames downloaded. From `launch-reel/`:
   ```bash
   # survey: a screen every 700 px, open them, pick the real moments
   SETTLE_MS=2600 node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/survey s0=0 s1=700 s2=1400 s3=2100 s4=2800
   # final shots at the positions you picked (OrderDi: hero=0 floor=1400 order=2100 kitchen=2450 pay=2950)
   SETTLE_MS=2600 node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/phone hero=0 floor=1400
   # the real wordmark as a transparent PNG (find the logo's selector in capture/extracted/page.html)
   node tools/phone-shots.mjs https://<name>.apps.sv-academy.org/ assets/brand wordmark=@.brand
   ```
   Each shot is a 390x844 phone at 3x (1170x2532 JPEG). `name=#section` scrolls to a section, `name=@selector` saves one element as a transparent PNG. It scrolls in 200 px steps so scroll-driven sections react; raise `SETTLE_MS` if cards are caught mid-animation.
   - **One continuous scrolling screen.** Survey shots every 700 px do not tile. Shoot at `y = k x (844 - navHeight)`: with an 80 px fixed nav, `... assets/phone p0=0 p1=764 p2=1528 p3=2292`. At 3x, crop the nav from shot 0 into its own file (`ffmpeg -v error -i assets/phone/p0.jpg -vf crop=1170:240:0:0 -q:v 2 assets/screen/nav.jpg`) and each shot below the nav (`-vf crop=1170:2292:0:240` into `c0.jpg`, `c1.jpg` ...). A sticky bottom bar: crop it too and subtract its height from the step. Stack the crops as `<img>` elements in one `#strip` with `data-layout-ignore` (otherwise `check` warns `escaped_container`), pin the nav above it, and tween the strip's `y`. Offset = site px x screen scale: on a 585 px wide screen (1.5x), site 700 px is `y: -1050`.
   - Do not put the live URL in an iframe: every render worker reloads the site and its wall-clock animations jump at worker boundaries. Not deterministic, and it needs the network.
   - Do not iframe the capture's `page.html` (glitch frames, font 404s, top of page only), and do not use Chrome's `--screenshot` flag below the hero (blank frames).
   - If the site opens on a gate (login, name card), is one thin screen, or is not live yet, ask the user for two or three phone screenshots of the real screens.
4. **Beat list**, 15 to 20 s. The verified 18 s shape:

   | Beat | Time | What happens |
   | --- | --- | --- |
   | Hook | 0 to 3 s | The customer's real pain as a question, in the bilingual order above, over a blurred real photo |
   | Reveal | 3 to 4.7 s | Soft iris into the brand world, wordmark, the site's one-line description |
   | Product | 4.7 to 12 s | Phone rises in 3D and scrolls the real screens, three callouts in the site's exact words, one or two camera push-ins on the detail that matters |
   | Tagline | 12 to 15 s | The site's promise, kinetic, in the bilingual order above |
   | Close | 15 to 18 s | Wordmark, offer line from the site, live address as text, "Made with SV Motion" |

5. **Build the reel in one file**, `compositions/reel.html`, as a `<template>` sub-composition; `index.html` is a thin host (canvas size, mounts the reel, music). Building it this way from the start makes Preset 2 free. Methods verified in the example:
   - **Each beat is its own timed clip.** Hook, reveal, product, tagline, close and each caption: its own element with `class="clip"`, `data-start`, `data-duration` and `data-track-index`. Otherwise every scene's text exists at every time and the first `check` fails (a fresh run: 32 layout and 20 contrast errors). `check` does not understand a `mask-image` iris: keep the masked brand layer at opacity 0 until the iris starts, and put `data-layout-allow-overlap` on text rows the iris deliberately covers.
   - Depth: blurred photo and glows at the back, a giant ghost word drifting behind the phone, framed photos drifting at another speed, the phone with its own shadow and moving glare, callout cards in front, captions on top, then light leak, vignette and grain. The ghost word needs enough contrast in every size to read as a word, not texture.
   - 3D phone: `perspective` on a wrapper, `rotationX`/`rotationY` on the child. Camera: one wrapper whose x, y and scale you tween for push-ins.
   - Callouts and captions sit outside the camera wrapper (inside it, a push-in shoves a card past the 9:16 edge). One callout at a time: the next one's entrance is the previous one's exit. Place each beside the part of the phone screen it names, never over it.
   - Reveals: masked lines with `yPercent` plus `filter: blur()`. Never scale inside a mask (clips Thai). Soft iris: CSS `mask-image: radial-gradient(...)` driven by a custom property (`tl.fromTo(el, {"--iris":"0%"}, {"--iris":"160%"})`), not a hard `clip-path: circle()`.
   - Mark full-frame decoration (grain, vignette) with `data-layout-ignore`.
6. **Captions.** Two lines in the bilingual order above, the site's sans, first line semibold, second regular, on a dark glass pill: the brand's darkest ink at about 84% opacity with a 12 px backdrop blur. Hide them when the words are already on screen (tagline, close).
7. **Sound.** A music bed synthesised with FFmpeg, no samples and no licences: adapt `tools/make-sound.sh` from this skill (move its hit times to your beats). Add it as its own `<audio>` element in the host, around -16 LUFS.
8. **Gate**: `lint`, then `check` until it passes, then `snapshot --at <one time per beat> --no-end` and open the PNGs. Each run replaces the frame PNGs in its folder: use `-o snapshots/<name>` for frames you want to keep. Every line must stay on screen long enough to read (at least about 1.5 s); a reveal line gone in under a second is a defect.
9. **Preview**: start it and give the Studio URL (Classroom mode, step 3).
10. **Render and look**:
    ```bash
    npx -y hyperframes@0.8.75 render -o renders/reel-9x16.mp4
    ffprobe -v error -show_entries stream=codec_type,width,height -show_entries format=duration renders/reel-9x16.mp4
    bash tools/stills.sh renders/reel-9x16.mp4      # six stills plus a contact sheet in renders/stills/
    ```

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

## Preset 3: personalised batch (one list, many videos)

1. Make it its own project so `check` works on it: `npx -y hyperframes@0.8.75 init welcome --non-interactive --resolution portrait`.
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
   `--strict-variables` stops the batch on an undeclared key. With `--variables`, keys you leave out fall back to the declared defaults. Use real customer names only with their permission; label sample rows as invented.

## Preset 4 (optional): voiceover

Only this was verified. The captioned video without a voice is the main deliverable and stands on its own.

- Engine: macOS `say` with a Thai system voice. List them with `say -v '?' | grep -i th`. Thai voices depend on the machine (the test Mac had only Kanya). It sounds synthetic; a person must listen before it is shown, and it is labelled "macOS system voice (Kanya)", never HeyGen.
- `hyperframes tts` (Kokoro) has no Thai (`--lang` is en-us, en-gb, es, fr-fr, hi, it, pt-br, ja, zh). HeyGen voices need a HeyGen account and key; not tested here. Windows has no `say`; untested.
- Method: speak the same words as the captions, one file per line (`say -v Kanya -r 185 -o line1.aiff "..."`), place each line on its caption time with FFmpeg `adelay`, pad to the video length, `loudnorm=I=-16:TP=-1.5`, write 48 kHz stereo WAV.
- Mix in a separate host (for example `sizes/showcase-vo.html`) with two `<audio>` elements: the bed at `data-volume="0.45"`, the voice at `1`. Render it with `-c`.
- Check it: a transcription of the final MP4 should read back the script. Whisper large-v3-turbo did for Kanya. `hyperframes transcribe` was not tested on Thai.

## Composing

- **Shape.** One root element with `data-composition-id`, `data-width`, `data-height`, `data-start`, `data-duration`. Timed children carry `class="clip"`, `data-start`, `data-duration`, `data-track-index`. Track index is scheduling, not stacking (use `z-index`), and two clips on one track cannot overlap in time. Duration is authoritative. Media plays through its own `<audio>` element; video elements stay muted.
- **Still frame first.** Write the CSS for the moment each scene has fully arrived, get that frame right as static markup, then animate from offscreen or invisible into it. Scene containers fill their parent; children use flex and gap. Absolute positioning is for decoration.
- **One paused timeline per composition,** built synchronously and registered once: `window.__timelines["reel"] = tl;`. A sub-composition's timeline cannot touch the host, so everything that moves lives in the reel file.
- **Directed, not generated.** First movement at 0.1 to 0.3 s, never 0. Mix eases per scene (back, expo, power, sine). Every element gets its own entrance. Transitions do the exit work; fade-outs only on the last beat.
- **Never put `back` or `elastic` eases on `filter` or `opacity`.** The overshoot pushes `blur()` below zero, which is invalid CSS: the element stays blurred through its entrance and a frame can depend on the previous seek. Split the tween: `back.out` on x or y, `power2.out` on opacity plus blur, same start.
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

`validate` and `inspect` still run in 0.8.75 but are deprecated in favour of `check`. Read the findings, do not skim for pass or fail. Expected `info` findings from these methods, leave them alone: `container_overflow` on a `.mask` while its line waits below it, `panel_out_of_canvas` while the phone rises from off canvas, `text_occluded` on text under a closed iris. Overflow means: more room, smaller type, a real `max-width`, or copy too long for the beat. Fix contrast by pushing an existing brand colour lighter or darker, never by inventing one. `composition_file_too_large` on the one-file reel is advisory and acceptable. After the render: `ffprobe` for size, duration and an audio stream, then `tools/stills.sh` and actually open the contact sheet.

## When it fails

| Symptom | Cause and fix |
| --- | --- |
| Render dies or produces nothing | `doctor`: usually FFmpeg, or Chrome (`browser ensure --force`) |
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
| lint `gsap_repeated_fromto_without_baseline` | One `tl.set(..., 0)` baseline, then `to` tweens |
| lint `duplicate_media_discovery_risk` | One image used in several places: crop each use into its own file |
| check `content_overlap` on rotated cards | `data-layout-allow-overlap` on each text row; it is not inherited from a wrapper |
| check `text_occluded` as an error before an entrance | Word waiting below its mask: enter with opacity plus x instead |
| Thai word clipped mid-entrance | `scale` inside an `overflow: hidden` mask: use `yPercent` plus blur |
| Hard-edged empty circle in a transition | `clip-path: circle()` iris: use a `mask-image` radial gradient, start the logo earlier |
| "Not inlining ... exceeds the 2 MB inline limit" | PNG screens: use JPEG quality 92 |
| Caption unreadable over busy UI | Glass too thin: about 84% plus backdrop blur |

## Editing something that already exists

Read the file first. Take the real hex values, eases and timings from the source, change only what was asked, and leave every unrelated clip's timing alone. The composition is its own specification.

## Codex and other agents

This skill is plain markdown. An agent without skill support can be told:

```text
Read https://raw.githubusercontent.com/sva-admin/sv-motion/main/SKILL.md and follow it for everything we do in this session.
```

The helper scripts sit next to it in the repo: `tools/phone-shots.mjs`, `tools/stills.sh` (bash), `tools/make-sound.sh` (bash; on Windows run it in Git Bash or WSL, or ask the agent to port it, untested).

## Credit

HyperFrames is created and maintained by HeyGen: <https://github.com/heygen-com/hyperframes>. All credit for the engine, the CLI and the runtime belongs to them. SV Motion is an independent SV Academy usage guide, licensed MIT, containing none of their code or documentation.

Learn it free: <https://loop.sv-academy.org/articles/video-from-a-text-file>
