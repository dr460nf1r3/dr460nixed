FROM archlinux:latest

LABEL maintainer="dr460nf1r3 <root@dr460nf1r3.org>"

RUN pacman --noconfirm -Syu base-devel fish micro pacman-contrib \
  && rm -rf /var/cache/pacman/pkg/*

RUN useradd builder -m \
  && passwd -d builder \
  && mkdir -p /run/user/1000 \
  && chown 1000:1000 /run/user/1000 \
  && printf 'builder ALL=(ALL) ALL\n' | tee -a /etc/sudoers
    
USER builder

WORKDIR /build
