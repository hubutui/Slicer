FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Ubuntu 26.04 (resolute) provides Qt 6.10.2 packages.
RUN grep -q '^Components:.*\buniverse\b' /etc/apt/sources.list.d/ubuntu.sources || \
      sed -i -E 's/^(Components:.*)$/\1 universe/' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      binutils \
      build-essential \
      cmake \
      file \
      gawk \
      ninja-build \
      patch \
      subversion \
      xz-utils \
      libssl-dev \
      libxt-dev \
      fontconfig \
      libfontconfig-dev \
      libfreetype-dev \
      libgtk-3-dev \
      libx11-dev \
      libx11-xcb1 \
      libxcb1-dev \
      libxcb-cursor-dev \
      libxcb-render-util0-dev \
      libxcb-image0-dev \
      libxcb-keysyms1-dev \
      libxcb-icccm4-dev \
      libxcb-util-dev \
      libxcb-xinerama0 \
      libxcb-xkb-dev \
      libxrender-dev \
      libxext-dev \
      libxfixes-dev \
      libxi-dev \
      libxkbcommon-dev \
      libxkbcommon-x11-dev \
      x11proto-dev \
      libatk-bridge2.0-dev \
      libgl1-mesa-dev \
      libegl1-mesa-dev \
      xserver-xorg-core \
      mesa-utils \
      libgl1-mesa-dri \
      alsa-utils \
      libasound2t64 \
      libxcomposite1 \
      libxcursor1 \
      libxrandr2 \
      libxtst6 \
      nss-plugin-pem \
      libegl1 \
      libpulse0 \
      libpulse-mainloop-glib0 \
      libreadline-dev \
      libncurses-dev \
      libgdbm-dev \
      libnss3-dev \
      libuuid1 \
      libusb-1.0-0-dev \
      xvfb \
      qt6-base-dev \
      qt6-base-private-dev \
      qt6-multimedia-dev \
      qt6-tools-dev \
      qt6-svg-dev \
      qt6-5compat-dev \
      qt6-webengine-dev \
      qt6-scxml-dev \
      qt6-declarative-dev && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
