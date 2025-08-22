FROM archlinux

#RUN apk add --no-cache openjdk17 ffmpeg
RUN pacman -Syu --noconfirm \
	&& pacman -S --noconfirm  jdk21-openjdk ffmpeg wget adwaita-fonts \
	&& pacman -Scc --noconfirm
RUN wget "https://download.gpx-animator.app/gpx-animator-1.8.2-all.jar" -O /usr/local/lib/gpx-animator.jar
WORKDIR /app

COPY --chmod=0775 render.sh /usr/bin/
ENTRYPOINT ["/usr/bin/render.sh"]
