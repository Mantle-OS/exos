ARG DEBIAN_TAG=sid-slim
FROM debian:sid-slim
ARG SOURCE_DATE_EPOCH
ENV DEBIAN_BASE_IMAGE_TAG=${DEBIAN_TAG}

ARG TARGETPLATFORM=linux/amd64
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get install --no-install-recommends -y \
        python3-pip python3-setuptools python3-wheel python3-yaml python3-distro python3-jsonschema \
        python3-newt python3-colorlog python3-kconfiglib python3-websockets \
        gosu lsb-release file vim less procps tree tar bzip2 zstd pigz lz4 unzip tmux libncurses-dev \
        git-lfs mercurial iproute2 ssh-client telnet curl rsync gnupg awscli sudo \
        socat bash-completion python3-shtab python3-git kas \
        gawk wget git diffstat unzip texinfo \
        gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl-mesa0 libegl1-mesa-dev libsdl1.2-dev \
        pylint xterm python3-subunit mesa-common-dev zstd nano \
        && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        apt-get install --no-install-recommends -y gcc-multilib g++-multilib; \
    fi && \
    rm -rf /var/log/* /tmp/* /var/tmp/* /var/cache/ldconfig/aux-cache

# https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg2023202.html
RUN ln -sf /usr/bin/lz4 /usr/bin/lz4c

RUN rm -f /etc/gitconfig && \
    git config --system filter.lfs.clean 'git-lfs clean -- %f' && \
    git config --system filter.lfs.smudge 'git-lfs smudge -- %f' && \
    git config --system filter.lfs.process 'git-lfs filter-process' && \
    git config --system filter.lfs.required true

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install --no-install-recommends -y libc6-dev-i386 libc6:i386 && \
    rm -rf /var/log/* /tmp/* /var/tmp/* /var/cache/ldconfig/aux-cache

COPY entrypoint.sh /usr/bin

RUN chmod 0755 /usr/bin/entrypoint.sh && \
    echo "mantle ALL=NOPASSWD: ALL" > /etc/sudoers.d/mantle-nopasswd && \
    chmod 660 /etc/sudoers.d/mantle-nopasswd && \
    echo "Defaults env_keep += \"ftp_proxy http_proxy https_proxy no_proxy\"" \
    > /etc/sudoers.d/env_keep && chmod 660 /etc/sudoers.d/env_keep && \
    groupadd mantle -g 1000 && \
    useradd mantle -u 1000 -g 1000 --create-home --home-dir /mantle

RUN mkdir -p /srv/yocto && \
    chown -R mantle:mantle /srv/yocto

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
