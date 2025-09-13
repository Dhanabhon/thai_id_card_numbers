# Demo Recording Guide

Follow these steps to create a small, crisp GIF and a screenshot for the README/pub.dev page.

## 1) Capture a short video (MP4)
- macOS: QuickTime Player → File → New Screen Recording → record ≤ 10s → save as `demo.mp4`.
- Windows: Win + G (Xbox Game Bar) → Capture → record ≤ 10s.
- Linux: GNOME Screen Recorder (Shift + Ctrl + Alt + R) or Peek.

Keep the app window around 800px wide and show the essential flow: type → validate → generate.

## 2) Trim (optional)
- GUI: QuickTime (macOS) → Edit → Trim.
- CLI: `ffmpeg -i demo.mp4 -ss 00:00:01 -to 00:00:10 -c copy demo_trim.mp4`

## 3) Convert to GIF
Option A — ffmpeg + gifski (recommended quality):
- `ffmpeg -i demo_trim.mp4 -vf scale=800:-1 -r 12 -f image2pipe -vcodec png - | gifski -o docs/demo.gif --quality 80 --fps 12 -`

Option B — ffmpeg + ImageMagick:
- `ffmpeg -i demo_trim.mp4 -vf fps=12,scale=800:-1:flags=lanczos docs/frames/%04d.png`
- `convert -delay 8 -loop 0 docs/frames/*.png -layers Optimize docs/demo.gif`

## 4) Optimize (optional)
- `gifsicle -O3 docs/demo.gif -o docs/demo.gif`

## 5) Screenshot
- Capture a clean state (valid ID shown). Save as `docs/screenshot.png`. Crop to the focused UI region.

## Conventions
- Duration: ≤ 10s, Width: ~800px, FPS: 10–15.
- Place outputs at: `docs/demo.gif` and `docs/screenshot.png`.
- Keep file sizes small for pub.dev.
