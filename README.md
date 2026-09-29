<p align="center"><a href="https://loop.sv-academy.org"><img src="https://raw.githubusercontent.com/sva-admin/claude-skills/main/assets/sv-academy-512.png" width="96" alt="Silicon Valley Academy"/></a></p>

# SV Motion

**The video is a text file.** One HTML file your coding agent writes and you can read, rendered to MP4 on your own machine. SV Academy's own skill, in **one file**: [`SKILL.md`](SKILL.md) holds the whole method, including the helper scripts, so Claude Code and Codex get exactly the same thing.

The engine is an open source tool that renders an HTML file to MP4. You never install it: the skill runs it as `npx -y hyperframes@0.8.75`.

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

That one file is all either agent needs.

## Three ways in

| You have | Way | What the agent does |
| --- | --- | --- |
| A live website address | 1. From your live site | Captures your site, takes real phone screenshots and makes the launch reel. |
| Your project's code on this machine (no public link needed) | 2. From your code | Reads the code for your real words, colours, fonts and screens, says the story back to you, then builds it. |
| A Remotion (React) video, from a template, a tutorial or another agent | 3. Bring in a Remotion video | Checks for anything that will not carry over (and stops if so), brings it into one HTML file, renders both, compares them side by side and lists what did not carry over. |

Made a launch video with [/brag](https://github.com/latent-spaces/brag) (MIT)? Classic `/brag` already writes this kind of HTML file, so the presets below work on it as it is. If it, or any other agent, hands you a Remotion project, way 3 brings it into one text file, and then everything below works on it. Way 2 is SV Academy's own take on a video from your code.

## Then, from the same file

| Preset | Prompt |
| --- | --- |
| Launch reel, 9:16 | `Use SV Motion to make a 15 to 20 second 9:16 launch reel from my live site, with real phone screenshots, my brand, Thai and English captions and my address on the last frame.` |
| From my code | `Use SV Motion to make a launch video from the code in this folder. Say the plan back to me first.` |
| Bring in a Remotion video | `Use SV Motion to bring my Remotion video in my-video into one file, list anything that did not carry over, then show me a preview.` |
| Same project, three sizes | `Use SV Motion to make the same reel in 16:9 for a big screen and 1:1 for Facebook from the one file, with one render command per size.` |
| Personalised batch | `Use SV Motion to make a 7 second welcome video with my customer's name as a variable, a rows.json of three examples, and render them all with render --batch.` |
| Captions from a recording | `Use SV Motion to add Thai and English captions to my recording, voice.m4a, timed to what I say. Here is what I say, one line per sentence:` and then the lines |
| Slides you present | `Use SV Motion to turn these five points into slides in my brand, in one file I can present from my laptop.` |

## What it does

- **Pre-flight first.** Node, FFmpeg and `doctor` before a single scene, with the fix for macOS and Windows.
- **Your brand, real assets.** Colours, fonts, words and wordmark come from your own site or your own code, and the phone screens are real screenshots, scrolling as one continuous screen. No stock footage, no invented numbers. If your description and your site disagree, the site wins and the agent asks you.
- **Thai done properly.** The site's Thai font (or a matching free Google Thai face when the site ships none, and the agent tells you), room for tone marks, no letter spacing, in your site's own language order. Any line the agent translates is flagged for you to approve before you share it.
- **Beat list, preview, then render.** You see plain sentences and scrub a live preview before anything slow runs.
- **Fix it in words.** Say what to change ("make my web address bigger on the last frame"); the agent changes only that and renders again.
- **Reproducible.** The same frames on every machine and every worker count.
- **Ready to send.** Six stills to check, plus a small share copy for LINE (about 5 MB instead of 12 to 35 MB).

## Requirements

Node.js 22 or newer, FFmpeg, and an internet connection (the engine, Chrome, your site and the animation library all load over the network; in Codex, allow network access). The skill runs every command as `npx -y hyperframes@0.8.75` so a whole class gets identical behaviour; upgrade on purpose. If a render fails, run `npx -y hyperframes@0.8.75 doctor` first. A cross on its Version line that only says a newer release is available is expected: do not upgrade.

Before a class, at home, so the room's Wi-Fi only has to load your site:

```bash
npx -y hyperframes@0.8.75 doctor
npx -y hyperframes@0.8.75 browser ensure
```

How long it takes, measured on an M3 Max with fresh agents reading only `SKILL.md`: from your live site, the live preview in about 12 minutes and the MP4 a minute later; from your code, about 9 and 10 minutes; bringing in a short Remotion video, about 3 and 3.5 minutes. An 18 second render takes 15 to 40 seconds, depending on the effects. An 8 GB laptop renders with one worker, so expect several minutes. On Windows, the two bash helper scripts need Git Bash or WSL (untested).

The [`tools/`](tools/) folder is a mirror of the helper scripts for old links. `SKILL.md` is the source of truth.

## License

MIT, for the SV Academy text and scripts in this repository, written in our own words. See [LICENSE](LICENSE).

## More from Silicon Valley Academy

- All of our published skills: [github.com/sva-admin/claude-skills](https://github.com/sva-admin/claude-skills)
- Courses and free lessons: [sv-academy.org](https://sv-academy.org)
