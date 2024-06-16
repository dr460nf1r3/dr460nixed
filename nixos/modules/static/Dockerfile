FROM archlinux:latest

LABEL maintainer="dr460nf1r3 <root@dr460nf1r3.org>"

# Set up a basic Arch container with Chaotic-AUR enabled
# makepkg flags: https://github.com/chaotic-aur/toolbox/pull/105
RUN curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" && \
  sed -i 's/^#//' /etc/pacman.d/mirrorlist && echo "RemoteFileSigLevel = Never" >> /etc/pacman.conf && \
  echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf && \
  echo -e "OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)\nBUILDENV=(!distcc !color !ccache check !sign)" >> /etc/makepkg.conf && \
  pacman -Syu --noconfirm base-devel namcap sudo git fish micro pacman-contrib && \
  pacman -Scc --noconfirm

RUN useradd builder -m \
  && passwd -d builder \
  && mkdir -p /run/user/1000 \
  && chown 1000:1000 /run/user/1000 \
  && printf 'builder ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builder

WORKDIR /build
