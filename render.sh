#! /bin/bash

WIDTH=720
HEIGHT=1600

while [ "$#" -gt 0 ]; do
  case "$1" in
    --week) WEEK=1; shift 1;;
    --landscape) WIDTH=1280; HEIGHT=720; shift 1;;
    --hd) HD=1; shift 1;;
    -*) echo "unknown option: $1" >&2; exit 1;;
    *) DIR="${1%/}"; shift 1;;
  esac
done

if [[ $WEEK == 1 ]]; then
	args=(--speedup 12000)
else 
	args=(--speedup 4000 --track-icon-file ./bus.png --zoom 9)
fi

if [[ $HD == 1 ]]; then 
	WIDTH=$WIDTH * 2
	HEIGHT=$HEIGHT * 2
fi

echo "$WIDTH x $HEIGHT"

for file in ${DIR}/*.gpx; do
	args+=(--input $file)
done

/usr/bin/java -jar /usr/local/lib/gpx-animator.jar \
	${args[@]} \
	--output ${DIR}.mp4 \
	--tms-url-template https://tile.openstreetmap.org/{zoom}/{x}/{y}.png \
	--width $WIDTH \
	--height $HEIGHT \
	--track-icon-mirror \
	--background-map-visibility 0.9 \
	--keep-last-frame 2000 \
	--line-width 4.0 \
	--font "Adwaita Sans-PLAIN-64" \
	--information-margin -300 \
	--attribution "${DIR/_/ }" \
	--attribution-margin 96 \
	--attribution-position "top right" \
	--flashback-duration 0
	
