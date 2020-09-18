FROM debian:buster-slim
ARG NEW_USER="ntrrg"
ARG MIRROR="http://deb.debian.org/debian"
RUN \
  echo "deb $MIRROR buster main contrib non-free" > /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y sudo && \
  useradd --shell "/bin/zsh" --create-home "$NEW_USER" && \
  echo "\n$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR "/tmp/post-install"
COPY post-install.sh .
RUN \
  DEBIAN_FRONTEND="noninteractive" GUI_ENABLED=0 CONTAINER=1 HARDWARE=0 BASEPATH="/tmp/post-install" \
  /tmp/post-install/post-install.sh && cd / && rm -rf /tmp/post-install
USER "$NEW_USER":"$NEW_USER"
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

