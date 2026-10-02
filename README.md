# codecs

Builds a patched **Electron** (Chromium) with extra media codecs:

- HEVC / H.265
- AC-3, E-AC-3, AC-4
- DTS, TrueHD
- plus the usual Chrome set (H.264, VP8/VP9, AV1, AAC, MP3, Opus, Vorbis, FLAC)

Uses patches from <https://github.com/5rahim/electron-media-patch>.
This repo builds **only Electron** — not any application.

## Build

1. Push this repo to GitHub (Actions must be enabled).
2. Go to **Actions → Build Electron with media codecs → Run workflow**.
3. Inputs:
   - `electron_version`: `v42.4.0` (must match `patches/<tag>` in the patch repo)
   - `patches_repo`: `5rahim/electron-media-patch`
   - `target`: `linux`, `windows` or `both`
4. Wait (typically 2–4 hours). Then open the finished run and download the
   artifact, e.g. `electron-linux-v42.4.0`.

Downloaded artifacts are wrapped in a zip, which contains the actual Electron
dist zip (`electron-v42.4.0-linux-x64.zip`). Unzip the artifact to get it.

## Use it

```bash
cd /path/to/spermio/app
npm run fetch -- --url ~/Downloads/electron-v42.4.0-linux-x64.zip \
  --key linux-x64-custom --version 42.4.0
npm start
```

Windows: `--key win-x64-custom`. `npm run dist:linux` / `dist:win` then package
with this Electron automatically.

Note: these patches only change build behavior; they grant no codec/patent
licenses. See the patch repo for details.
