FROM docker:19 as docker

FROM debian:bullseye-slim
ARG NEW_USER="ntrrg"
ARG MIRROR="http://deb.debian.org/debian"
RUN \
  echo "deb $MIRROR bullseye main contrib non-free" > /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y sudo && \
  useradd --shell "/bin/zsh" --create-home "$NEW_USER" && \
  echo "\n$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
WORKDIR "/tmp/post-install"
COPY post-install.sh .
RUN \
  DEBIAN_FRONTEND="noninteractive" BASEPATH="/tmp/post-install" \
  IS_CONTAINER=1 IS_GUI=0 IS_HARDWARE=0 \
  /tmp/post-install/post-install.sh && cd / && rm -rf /tmp/post-install
USER "$NEW_USER":"$NEW_USER"
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

