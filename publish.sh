#!/usr/bin/env bash
# Pushuje workflow do GitHub i uruchamia build patched Electrona.
# Wymaga jednorazowego logowania:  gh auth login
set -euo pipefail
cd "$(dirname "$0")"

GH="$(command -v gh 2>/dev/null || echo "$HOME/.local/bin/gh")"

if ! "$GH" auth status >/dev/null 2>&1; then
  echo "Najpierw zaloguj sie do GitHub (jednorazowo):"
  echo "  $GH auth login"
  exit 1
fi

"$GH" auth setup-git >/dev/null 2>&1 || true

echo "==> push do GitHub"
git push -u origin main

echo
echo "==> uruchamiam workflow (linux, v42.4.0)"
"$GH" workflow run build-electron-codecs.yml \
  -f electron_version=v42.4.0 \
  -f patches_repo=5rahim/electron-media-patch \
  -f target=linux

sleep 4
echo
echo "==> ostatnie runy:"
"$GH" run list --workflow=build-electron-codecs.yml --limit 3 || true

cat <<'TIP'

Build trwa zwykle 2-4 h. Podglad:
  gh run watch
Artefakt po zakonczeniu:
  gh run download --name electron-linux-v42.4.0 -D ~/Downloads/codecs
Potem w aplikacji:
  cd /home/sherfy/www/spermio/app
  npm run fetch -- --url ~/Downloads/codecs/electron-v42.4.0-linux-x64.zip \
    --key linux-x64-custom --version 42.4.0
  npm start
TIP
