#!/bin/bash

tmpfile=$(mktemp)
(
  fdfind . ~/projects ~/documents ~/downloads/ ~/pictures \
    --type f \
    -e pdf \
    --exclude .git \
    --exclude node_modules \
    --exclude build \
    --exclude .cache \
    --exclude "*.root" \

  fdfind . ~/projects ~/documents ~/downloads/ ~/pictures \
    --type f \
    --exclude .git \
    --exclude node_modules \
    --exclude build \
    --exclude .cache \
    --exclude "*.root" \
    --exclude "*.pdf"
) 2>/dev/null | \
awk -F/ '
{
  full=$0
  name=$NF

  # build short context (last 1–2 folders)
  n=NF
  if (n > 2) {
    context=$(NF-2) "/" $(NF-1)
  } else if (n > 1) {
    context=$(NF-1)
  } else {
    context="."
  }

  # icons
  if (name ~ /\.pdf$/) icon="📄";
  else if (name ~ /\.(png|jpg|jpeg)$/) icon="🖼️";
  else if (name ~ /\.root$/) icon="🧪";
  else if (name ~ /\.py$/) icon="🐍";
  else icon="📁";

  shown=icon " " name "   [" context "]"

  print shown "\t" full
}' > "$tmpfile"

choice=$(cut -f1 "$tmpfile" | rofi -dmenu -i -p "Files")

[ -z "$choice" ] && rm -f "$tmpfile" && exit

filepath=$(grep -F "$choice" "$tmpfile" | head -n1 | cut -f2-)

[ -n "$filepath" ] && xdg-open "$filepath" >/dev/null 2>&1 &

rm -f "$tmpfile"
