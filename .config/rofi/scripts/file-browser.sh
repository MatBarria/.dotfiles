#!/bin/bash

#fdfind . ~/projects ~/Documents ~/Downloads/ ~/Pictures \
  #--type f \
  #--exclude .git \
  #--exclude node_modules \
  #--exclude build \
  #--exclude .cache \
  #--exclude "*.root" \
  #2>/dev/null | \
#awk '{
  #if ($0 ~ /\.pdf$/) icon="📄";
  #else if ($0 ~ /\.png$|\.jpg$|\.jpeg$/) icon="🖼️";
  #else if ($0 ~ /\.root$/) icon="🧪";
  #else if ($0 ~ /\.py$/) icon="🐍";
  #else icon="📁";
  #print icon " " $0
#}' | \
#rofi -dmenu -i -markup-rows -p "Files" -show-icons | \
#sed 's/^[^ ]* //' | \
#xargs -r xdg-open

#!/bin/bash

tmpfile=$(mktemp)

fdfind . ~/projects ~/Documents ~/Downloads/ ~/Pictures \
  --type f \
  --exclude .git \
  --exclude node_modules \
  --exclude build \
  --exclude .cache \
  --exclude "*.root" \
  2>/dev/null | \
awk -F/ '
{
  full=$0
  name=$NF

  if (name ~ /\.pdf$/) icon="📄";
  else if (name ~ /\.(png|jpg|jpeg)$/) icon="🖼️";
  else if (name ~ /\.root$/) icon="🧪";
  else if (name ~ /\.py$/) icon="🐍";
  else icon="📁";

  shown=icon " " name
  print shown "\t" full
}' > "$tmpfile"

choice=$(cut -f1 "$tmpfile" | rofi -dmenu -i -p "Files")

[ -z "$choice" ] && rm -f "$tmpfile" && exit

filepath=$(grep -F "$choice" "$tmpfile" | head -n1 | cut -f2-)

[ -n "$filepath" ] && xdg-open "$filepath" >/dev/null 2>&1 &

rm -f "$tmpfile"
