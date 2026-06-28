FROM archlinux:latest

ENV QT_QPA_PLATFORM=offscreen \
    QTWEBENGINE_DISABLE_SANDBOX=1 \
    XDG_RUNTIME_DIR=/tmp/runtime-root

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
      alsa-lib \
      alsa-utils \
      base-devel \
      binutils \
      ca-certificates \
      ccache \
      cmake \
      file \
      fontconfig \
      freetype2 \
      gawk \
      gdbm \
      git \
      gtk3 \
      libpulse \
      libusb \
      libx11 \
      libxcomposite \
      libxcursor \
      libxext \
      libxfixes \
      libxi \
      libxkbcommon \
      libxkbcommon-x11 \
      libxrandr \
      libxrender \
      libxt \
      libxtst \
      mesa \
      mesa-utils \
      ncurses \
      ninja \
      nss \
      openssl \
      patch \
      qt6-5compat \
      qt6-base \
      qt6-declarative \
      qt6-multimedia \
      qt6-scxml \
      qt6-svg \
      qt6-tools \
      qt6-webchannel \
      qt6-webengine \
      readline \
      rsync \
      subversion \
      util-linux-libs \
      xcb-util \
      xcb-util-cursor \
      xcb-util-image \
      xcb-util-keysyms \
      xcb-util-renderutil \
      xcb-util-wm \
      xorg-server-xvfb \
      xorgproto \
      xz && \
    pacman -Scc --noconfirm

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
