---
name: hyperframes
description: Turn a written brief into a rendered MP4 with HyperFrames, the open-source video engine by HeyGen where the video itself is an HTML file. Use for social clips, launch teasers, title cards, animated stat callouts, captioned audio, and any video that has to be re-cut every time the copy changes. Trigger on "make a video from this", "turn this text into a video", "render this as an MP4", "hyperframes", "video from my script", "animated title card", "add captions to this audio", "re-render the video with the new numbers", "vertical clip for social".
---

# hyperframes

Silicon Valley Academy's working method for driving **HyperFrames**, an open-source video engine built and maintained by HeyGen: <https://github.com/heygen-com/hyperframes>.

SV Academy did not write that engine and does not ship a copy of it. This file is our own playbook for getting a good MP4 out of it in one or two passes instead of ten.

The premise worth holding onto: **the video is a text file.** Layout is markup, timing is attributes, motion is a script. Nothing is baked until the render command runs, so fixing a headline costs forty seconds of compute, not a re-shoot.

## Before the first run

Confirm the machine can actually render before writing a single scene. Wasting a user's attention on a composition that cannot compile is the worst failure mode here.

```bash
node --version            # needs 22 or newer
npx hyperframes doctor    # checks Chrome, FFmpeg, Node, free memory
```

If `doctor` complains, fix it and say so plainly. FFmpeg missing is the single most common cause of "it rendered nothing".

## The loop

Brief, scaffold, look, compose, check, render. Do them in that order. Every step skipped shows up as a re-render later.

## 1. Write the brief first

Never open an editor from a one-line request. Get these five answers, from the user or from the source document they handed you, and write them down before any markup exists:

| Question | Why it decides something |
| --- | --- |
| Who watches it, and where? | Feed, landing page, and conference loop want different densities |
| How long? | 8 to 15 seconds for social, 30 to 60 for a product walkthrough |
| What shape? | 1080x1920 vertical, 1920x1080 wide, 1080x1080 square |
| What is the one thing they should remember? | If you cannot name it, the video has no ending |
| Is there existing brand material? | Colors, fonts, logo files, or a design doc in the repo |

Then draft the beat list in plain sentences, one line per scene, with a rough second count on each. Show the beat list to the user before building. Approving five lines of text is cheap. Approving a finished render is not.

Build only what the beat list says. A request for a title card is a title card, not a title card plus three supporting scenes plus music. If an extra beat would genuinely help, propose it and wait.

## 2. Scaffold, do not hand-roll

The CLI creates the directory shape, drops media in the right place, transcribes audio if you give it audio, and wires the tooling. Hand-built folders drift from what the linter expects.

```bash
npx hyperframes init launch-teaser
npx hyperframes init launch-teaser --example blank --non-interactive   # agent-friendly
npx hyperframes init launch-teaser --audio narration.mp3
```

Run `npx hyperframes init --help` to see the current example templates rather than guessing at names that may have changed between releases.

## 3. Lock the look before you write markup

Reaching for `#333` and a system sans is how a video ends up looking like a bug report. Decide the palette and type before the first tag.

- If the project has a design document (`design.md`, `DESIGN.md`, a brand page, a style file), read it and use its literal values. Do not approximate a hex code from memory.
- If it names a typeface you cannot find on disk, say so before building and agree on a fallback. Silently substituting a font is how brand review fails.
- If there is nothing, ask three quick questions: light or dark, one accent color, and one mood word. Three answers beat an hour of guessing.

Brand material tells you what the video looks like. It does not tell you how video behaves. Video is watched from further away than a web page: type runs larger, contrast runs harder, and detail that reads fine in a browser disappears at 1080p on a phone. Headlines at 60px and up, body text at 20px and up, data labels no smaller than 16px.

## 4. Compose

### The shape of a file

A composition is one container element carrying an id and its pixel dimensions. Everything timed lives inside it. Each timed element declares when it starts, how long it lasts, and which track it sits on.

```html
<div data-composition-id="teaser" data-width="1080" data-height="1920">
  <section id="beat-open" data-start="0" data-duration="3.5" data-track-index="0">
    <h1 class="headline">Ship the idea today</h1>
    <p class="sub">Not the sprint after next</p>
  </section>

  <section id="beat-proof" data-start="3.5" data-duration="4" data-track-index="0">
    <span class="stat">12x</span>
    <span class="label">faster to a second draft</span>
  </section>
</div>
```

Two things trip people up here. Track index controls scheduling, not stacking: two clips on the same track cannot overlap in time, and visual layering is still plain CSS `z-index`. And duration is authoritative: the attribute decides how long a clip is on screen, not how long the animation happens to run.

Bigger pieces split into sub-compositions in their own files, mounted from the parent with a source path. Keep each file to one idea so a re-cut touches one file.

### Build the still frame, then animate it

Write the CSS for the moment each scene is fully arrived: everything on screen, correctly placed, nothing on its way out. Get that frame right as static markup.

Only then add motion, animating **from** an offscreen or invisible state **into** that resting position. The CSS is the truth and the animation is the trip there. Do it the other way round and you are guessing where things land, which is exactly the class of overlap bug that stays invisible until the MP4 exists.

Let the scene container fill its parent with percentage sizing and padding, and space children with flex and gap. Absolutely positioning a content block at fixed pixel offsets works until the copy runs one line longer, then it bleeds off frame. Save absolute positioning for decoration.

### One timeline, registered, paused

Each composition builds a single paused timeline and hands it to the runtime under its own id. The player owns playback from there.

```html
<script>
  window.__timelines = window.__timelines || {};
  const tl = gsap.timeline({ paused: true });

  tl.from("#beat-open .headline", { yPercent: 40, autoAlpha: 0, duration: 0.55, ease: "power4.out" }, 0.2);
  tl.from("#beat-open .sub",      { yPercent: 25, autoAlpha: 0, duration: 0.45, ease: "expo.out" }, 0.45);
  tl.from("#beat-proof .stat",    { scale: 0.85, autoAlpha: 0, duration: 0.5, ease: "back.out(1.6)" }, 3.6);

  window.__timelines["teaser"] = tl;
</script>
```

Three habits that separate a video that reads as directed from one that reads as generated:

- Start the first movement a beat late, around 0.1 to 0.3 seconds, never at zero.
- Vary the easing. Three identical `power2.out` entrances in one scene is a tell.
- Give every element its own entrance. Anything that simply appears fully formed looks like a rendering glitch.

Between scenes, let a transition do the exit work. Animating a scene's elements out and then cutting means the transition fires on an empty frame, which is the most common reason a first render feels hollow. Save fade-outs for the final beat.

## 5. Check before you render

Rendering is the slow step. Everything cheap runs first.

```bash
npx hyperframes lint       # structural problems: missing ids, track collisions, unregistered timelines
npx hyperframes validate   # deeper checks, including text contrast
npx hyperframes inspect    # drives it in headless Chrome and reports text spilling out of its box
npx hyperframes preview    # live studio in the browser, hot reloads on save
```

Read what `inspect` reports rather than skimming for a pass or fail. Overflow findings almost always mean one of four things: the container needs more room, the type needs to be smaller, the text needs a real `max-width` so it wraps, or the copy is simply too long for the beat. Fix the cause, not the symptom.

Contrast warnings get fixed by pushing an existing palette color lighter or darker, not by inventing a new one.

When you hand a preview to the user, give them the studio URL the preview command prints, not a file path to the markup. `index.html` is source, not the deliverable.

## 6. Render

```bash
npx hyperframes render --quality draft         # while you are still changing things
npx hyperframes render --output teaser.mp4     # the copy you send for review
npx hyperframes render --quality high --fps 60 # the file that actually ships
npx hyperframes render --format webm           # when you need a transparent background
```

Draft quality while you are still changing things, standard for review, high for the file that actually ships. Sixty frames per second roughly doubles render time, so spend it on the final pass only.

## Re-cuts without edits

This is the payoff worth teaching the user out loud. Declare the parts that change (a name, a price, a headline, a theme) as composition variables with sensible defaults, read them once at the top of your script, and override them at render time.

```bash
npx hyperframes render --variables '{"headline":"Cohort 2 opens in October","theme":"dark"}'
npx hyperframes render --variables-file ./variants/thai.json
```

Same source file, one command per variant. Localized cuts, per-customer versions, and weekly number updates stop being editing jobs and become arguments. Always ship a real default for every variable so the preview still renders correctly with nothing passed.

## Narration and captions

The CLI covers the audio side too: generating narration from text, transcribing audio to word-level timing, and cutting backgrounds out of footage. Check the current flags with `npx hyperframes <command> --help` before using them, since models and options move between releases.

Two rules that hold regardless of version. Video elements stay muted with a separate audio element carrying the sound, because the engine schedules media itself. And captions get their timing from a real transcript, never from a guess, since caption drift is the fastest way to make a polished video look amateur.

## Rules that keep a render reproducible

A render is many browser instances seeking to exact timestamps in parallel. Anything that produces a different result on the second read will produce a broken frame.

1. No randomness and no clock reads. No `Math.random()`, no `Date.now()`. If you need scatter, use a seeded generator so every worker computes the same values.
2. No infinite repeats. Compute the exact repeat count from the clip's duration instead.
3. Build timelines synchronously. Nothing inside `async`, `setTimeout`, or a promise chain: the runtime collects timelines immediately after load and will not wait.
4. Animate visual properties only. Transforms, opacity, color, radius. Never `display` or `visibility`, and never call play, pause, or seek on media yourself.
5. Never animate the same property of the same element from two timelines at once.
6. Do not force line breaks with `<br>` in body copy. Text that already wraps plus a manual break equals overlap. Constrain the width and let it wrap. Display titles where each word is deliberately its own line are the exception.

## When it fails

| Symptom | First thing to check |
| --- | --- |
| Render produces nothing or dies immediately | `npx hyperframes doctor`, usually FFmpeg or Chrome |
| Frames are blank | Timeline never registered under the composition id, or the container is missing its id |
| Clip never shows up | Two clips sharing a track index and overlapping in time |
| Motion looks right in preview, wrong in the file | Something non-deterministic, or a tween that outlives its clip's duration |
| Text is cut off | Run `inspect`, then fix the container rather than nudging pixels |

## Editing something that already exists

Read the actual file before changing it. Pull the real hex values, the real easing, the real timings out of the source instead of reconstructing them from memory. Change only what was asked, and leave the timing of every unrelated clip alone. A composition is its own specification.

## Credit

HyperFrames is created and maintained by HeyGen: <https://github.com/heygen-com/hyperframes>. All credit for the engine, the CLI, and the runtime belongs to them. Consult their documentation for the authoritative command and attribute reference. This file is an independent SV Academy usage guide, licensed MIT, and contains none of their code or documentation.

Learn the whole workflow free, step by step: <https://loop.sv-academy.org/articles/video-from-a-text-file>
