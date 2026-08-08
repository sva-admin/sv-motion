<p align="center"><a href="https://loop.sv-academy.org"><img src="https://raw.githubusercontent.com/sva-admin/claude-skills/main/assets/sv-academy-512.png" width="96" alt="Silicon Valley Academy"/></a></p>

# hyperframes

Write the video as a text file, then render it to MP4 on your own machine, so changing one word never means re-recording anything.

> **Transparency**
>
> HyperFrames is an open-source video engine by **HeyGen**: [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes). This repository is not that engine and contains no code or documentation from it.
>
> Inspired by HyperFrames by HeyGen ([github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes)). This is an independent SV Academy implementation: our own usage skill for driving their public tool well, written from scratch and licensed MIT.

Learn it free, step by step: [Make a video from a text file](https://loop.sv-academy.org/articles/video-from-a-text-file)

## Try it

Paste this into Claude Code:

```
Install the skill from https://github.com/sva-admin/hyperframes, then make me a 12-second vertical launch teaser from the beats in launch-notes.md and render it to MP4.
```

## What the skill does

It gives Claude a method instead of a blank page:

- **Brief before build.** Audience, length, aspect ratio, the one thing to remember, and any brand material get settled in five lines you can approve in ten seconds.
- **Beat list before markup.** You sign off on plain sentences, not on a finished render.
- **Still frame before motion.** Layout is built at rest first, then animated into, which is what stops elements from silently overlapping in the exported file.
- **Checks before rendering.** Lint, validate, and a headless layout inspection run before anything slow starts.
- **Re-cuts as arguments.** The parts that change become declared variables, so a localized or updated version is one render command, not an editing session.

It also carries the rules that make a parallel render come out identical every time: no randomness, no clock reads, no infinite loops, timelines built synchronously and registered by id.

## Requirements

The engine runs locally and does the real work. You need Node.js 22 or newer and FFmpeg on your machine. Run `npx hyperframes doctor` first if a render fails.

## Credit

All credit for HyperFrames itself, the engine, the CLI, and the runtime, belongs to HeyGen. Their repository is the authoritative reference for commands, attributes, and flags: [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes).

## License

MIT, for the SV Academy text in this repository. See [LICENSE](LICENSE).

## More from Silicon Valley Academy

- All of our published skills: [github.com/sva-admin/claude-skills](https://github.com/sva-admin/claude-skills)
- Courses and free lessons: [sv-academy.org](https://sv-academy.org)
