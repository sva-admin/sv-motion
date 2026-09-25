<p align="center"><a href="https://loop.sv-academy.org"><img src="https://raw.githubusercontent.com/sva-admin/claude-skills/main/assets/sv-academy-512.png" width="96" alt="Silicon Valley Academy"/></a></p>

# SV Motion

**The video is a text file.** One HTML file your coding agent writes and you can read, rendered to MP4 on your own machine with HyperFrames by HeyGen. From your live website: a launch reel, the same reel in three sizes, and a personalised video for every name on a list.

> **Transparency**
>
> HyperFrames is an open-source video engine by **HeyGen**: [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes). This repository is not that engine and contains no code or documentation from it. SV Motion is SV Academy's own usage skill for driving their public tool well, written from scratch and licensed MIT.

Learn it free, step by step: [Make a video from a text file](https://loop.sv-academy.org/articles/video-from-a-text-file)

## Install

Paste this into Claude Code:

```text
Install the skill from https://github.com/sva-admin/sv-motion, then make a 9:16 launch reel from my live site at https://<name>.apps.sv-academy.org/
```

Codex, or any agent without skills:

```text
Read https://raw.githubusercontent.com/sva-admin/sv-motion/main/SKILL.md and follow it for everything we do in this session.
```

## Three presets, one line each

| Preset | Prompt |
| --- | --- |
| Launch reel, 9:16 | `Use SV Motion to make a 15 to 20 second 9:16 launch reel from my live site, with real phone screenshots, my brand, Thai and English captions and my address on the last frame.` |
| Same project, three sizes | `Use SV Motion to make the same reel in 16:9 for the Demo Day screen and 1:1 for Facebook from the one file, with one render command per size.` |
| Personalised batch | `Use SV Motion to make a 7 second welcome video with my customer's name as a variable, a rows.json of three examples, and render them all with render --batch.` |

## What it does

- **Pre-flight first.** Node, FFmpeg and `doctor` before a single scene, with the fix for macOS and Windows.
- **Your brand, real assets.** Colours, fonts, words and wordmark come from a capture of your own site, and the phone screens are real screenshots of it, scrolling as one continuous screen. No stock footage, no invented numbers. If your description and your site disagree, the site wins and the agent asks you.
- **Thai done properly.** The site's Thai font (or a matching free Google Thai face when the site ships none, and the agent tells you), room for tone marks, no letter spacing, in your site's own language order. Any line the agent translates is flagged for you to approve before you share it.
- **Beat list, preview, then render.** You approve plain sentences and scrub a live preview before anything slow runs.
- **Reproducible.** The same frames on every machine and every worker count.
- **Ready to send.** Six stills to check, plus a small share copy for LINE (about 5 MB instead of 20 MB).

## Requirements

Node.js 22 or newer and FFmpeg. The skill runs every command as `npx -y hyperframes@0.8.75` so a whole class gets identical behaviour; upgrade on purpose. If a render fails, run `npx -y hyperframes@0.8.75 doctor` first.

Before a class, at home, so the room's Wi-Fi only has to load your site:

```bash
npx -y hyperframes@0.8.75 doctor
npx -y hyperframes@0.8.75 browser ensure
```

How long it takes: on an M3 Max a fresh agent reached the live preview in about 13 minutes and the first MP4 in about 17; the 18 second render itself took 15 seconds. An 8 GB laptop renders with one worker, so expect several minutes. On Windows, the helper scripts in `tools/` need Git Bash or WSL (untested).

## Credit

All credit for HyperFrames, the engine, the CLI and the runtime, belongs to HeyGen. Their repository is the authoritative reference for commands, attributes and flags: [github.com/heygen-com/hyperframes](https://github.com/heygen-com/hyperframes).

## License

MIT, for the SV Academy text and scripts in this repository. See [LICENSE](LICENSE).

## More from Silicon Valley Academy

- All of our published skills: [github.com/sva-admin/claude-skills](https://github.com/sva-admin/claude-skills)
- Courses and free lessons: [sv-academy.org](https://sv-academy.org)
