#!/usr/bin/env bash
#set -euo pipefail
cd $HOME/FXServer # Edit this with your directory

BASE="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
OUT="fx.tar.xz"
TMP_HTML="$(mktemp)"
trap 'rm -f "$TMP_HTML"' EXIT

echo "Searching for latest recommended build..."

URL=$(curl -s 'https://changelogs-live.fivem.net/api/changelog/versions/linux/server' | grep -oP '"recommended_download"\s*:\s*"\K[^"]+')
# Validate that $URL is a non-empty HTTPS URL; if not, run fallback.
if [[ -z "$URL" || ! $URL =~ ^https:// ]]; then
  echo "API Fail. Attemping rescue with a web fallback..."
  curl -sS "$BASE" > "$TMP_HTML"
  URL=$(awk -F'"' '/LATEST RECOMMENDED/{print p} {p=$2}' $TMP_HTML)
  URL="${BASE}${URL}"
fi

echo "Downloading: $URL"
wget -q --show-progress -O "$OUT" "$URL"

# Map $FILE to $OUT for the block integration
FILE="$OUT"

if [ -f "$FILE" ]; then
  echo "Checking if it's an XZ file using the 'file' command"
  FILE_TYPE=$(file "$FILE")

  if [[ "$FILE_TYPE" == *"XZ compressed data"* ]]; then
    echo "$FILE is OK a valid XZ."

    echo "Stoping FiveM service..."
    sudo /bin/systemctl stop fivem.service

    echo "Renaming existing alpine dir to alpine_old (force)..."
    if [ -d alpine ]; then
      # remove previous alpine_old if exists, then move alpine -> alpine_old
      rm -rf alpine_old
      mv -T alpine alpine_old
    fi

    echo "Extracing the tarball (creates alpine/ or appropriate files)..."
    tar xf "$OUT"
  else
    echo "Error: File $FILE is not an XZ compressed data archive."
    exit 1
  fi
else
  echo "Error: File $FILE not found (download may have failed)."
  exit 1
fi

echo "Starting FiveM service..."
sudo /bin/systemctl start fivem.service
