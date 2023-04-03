FROM debian:bookworm-slim

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Timezone
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bear \
        ca-certificates \
        ccls \
        clang \
        clangd \
        cmake \
        curl \
        fd-find \
        fzf \
        git \
        less \
        libeigen3-dev \
        libgoogle-glog-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgtest-dev \
        libopencv-dev \
        libsqlite3-dev \
        libswscale-dev \
        locales \
        make \
        nodejs \
        npm \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-pynvim \
        python3-setuptools \
        python3-wheel \
        ripgrep \
        sqlite3 \
        sudo \
        tree \
        unzip \
        wget \
        xclip \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN npm install -g neovim yarn prettier

# Install lazygit
RUN URL=https://github.com/jesseduffield/lazygit/releases/download/v0.37.0/lazygit_0.37.0_Linux_x86_64.tar.gz \
    && TMP=/tmp/$(echo $URL | sed 's/^.*[=\/]//') \
    && wget $URL -O $TMP \
    && cd /usr/local/bin \
    && tar xf $TMP lazygit \
    && rm $TMP

# Install NeoVim
RUN URL=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb \
    && TMP=/tmp/$(echo $URL | sed 's/^.*[=\/]//') \
    && wget $URL -O $TMP \
    && dpkg -i $TMP \
    && rm $TMP

# Install ripgrep
RUN URL=https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb \
    && TMP=/tmp/$(echo $URL | sed 's/^.*[=\/]//') \
    && wget $URL -O $TMP \
    && dpkg -i $TMP \
    && rm $TMP

COPY files/entrypoint.sh \
     files/launch-nvim.sh \
     /

ENTRYPOINT ["/entrypoint.sh"]

