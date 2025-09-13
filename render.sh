#! /bin/bash

WIDTH=720
HEIGHT=1600

while [ "$#" -gt 0 ]; do
  case "$1" in
    --week) WEEK=$2; shift 2;;
    --landscape) WIDTH=1280; HEIGHT=720; shift 1;;
    --zoom) ZOOM=$2; shift 2;;
    -*) echo "unknown option: $1" >&2; exit 1;;
    *) DIR="${1%/}"; shift 1;;
  esac
done

if [[ -n "$WEEK" ]]; then
	args=(--speedup $(( 16000 * $WEEK )))
else 
	args=(--speedup 4000)
fi

if [[ -n "$ZOOM" ]]; then 
	args+=(--zoom $ZOOM)
fi

for file in ${DIR}/*.gpx; do
	args+=(--input $file)
	if [[ -z "$WEEK" ]]; then 
		case $file in
			*ferry.gpx) args+=(--track-icon-file /usr/local/lib/ferry.png);;
			*cake.gpx) args+=(--track-icon-file /usr/local/lib/cake.png);;
			*) args+=(--track-icon-file /usr/local/lib/bus.png);;
		esac
	fi
done

/usr/bin/java -jar /usr/local/lib/gpx-animator.jar \
	${args[@]} \
	--output ${DIR}.mp4 \
	--tms-url-template https://tile.openstreetmap.de/{zoom}/{x}/{y}.png \
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
	
