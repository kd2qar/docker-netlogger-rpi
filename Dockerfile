#FROM ubuntu
#FROM debian:stable-slim
#FROM kd2qar/box86
FROM kd2qar/box64 AS box 
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y  libxcb1 \
                        libexpat1 \
                        libxdmcp6 \
                        libx11-xcb1 \
                        libfontconfig1 \
                        libfreetype6 \
                        libdbus-1-3 \
                        libx11-6 \
   && rm -rf /var/lib/apt/lists/*


FROM box AS setup

#RUN apt-get update && apt-get install -y vim aptitude && rm -rf /var/lib/apt/lists/*

COPY NetLogger*.tgz /root/

WORKDIR /root/

RUN tar xzf NetLogger*.tgz && \
    echo "/usr/local/share/netlogger">input.txt && \
    echo "/usr/local/bin">>input.txt && \
    cat input.txt | ./install 

RUN apt-get update &&\
	apt-get install -y libqt5core5a libqt5dbus5 libqt5gui5 libqt5widgets5 && \
	apt-get install -y -m libwxgtk3.0-gtk3-dev || (apt-get install -y -m libwxgtk3.0-dev) || apt-get install -y -m libwxgtk3.2-dev && \
    apt-get update && apt-get -y install firefox-esr && \
	rm -rf /var/lib/apt/lists/*
#RUN apt-get update && apt-get -y install firefox-esr && rm -rf  /var/lib/apt/lists/*

COPY netlogger_icons/128x128/netlogger.png /usr/share/icons/hicolor/128x128/apps/netlogger.png
COPY netlogger_icons/48x48/netlogger.png /usr/share/icons/hicolor/48x48/apps/netlogger.png
COPY netlogger_icons/512x512/netlogger.png /usr/share/icons/hicolor/512x512/apps/netlogger.png
COPY netlogger.desktop /usr/share/applications/netlogger.desktop
RUN  gtk-update-icon-cache -f -t /usr/share/icons/hicolor 

RUN rm -f /root/*.tgz /root/input.txt /root/install /root/README

FROM scratch
COPY --from=setup / /

#RUN apt-get update;
#RUN apt-get install -y vim x11-apps locate aptitude
#RUN updatedb
RUN echo "alias ls=\"ls --color\"">>root/.bashrc
RUN echo "alias ll=\"ls -alh\"">>/root/.bashrc

COPY nlbox /netlogger/nlbox
RUN chmod +x /netlogger/nlbox

#ENV BOX64_EMULATED_LIBS=libSDL2-2.0.so.0:libSDL2_ttf-2.0.so.0
#ENV BOX64_EMULATED_LIBS=libqjpeg.so:libqgif.so

## NOTE: THIS SETTING IS NECESSARY TO RUN NETLOGGER
# without this netlogger crashes after loading libraries
# I think it is the jpeg and/or gif plugin libraries.
ENV BOX64_PREFER_EMULATED=1
##
ENV DISPLAY=:0

SHELL ["/bin/bash", "-c" ]
CMD ["/bin/bash"]

