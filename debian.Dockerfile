FROM debian:bullseye-slim
ARG NEW_USER="ntrrg"
ARG MIRROR="http://deb.debian.org/debian"
WORKDIR "/tmp/post-install"
COPY post-install-debian.sh .
RUN \
  echo "deb $MIRROR bullseye main contrib non-free" > /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y sudo && \
  echo "\n$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  DEBIAN_FRONTEND="noninteractive" BASEPATH="/tmp/post-install" NEW_USER="$NEW_USER" IS_HARDWARE=0 \
  /tmp/post-install/post-install-debian.sh && \
  cd / && rm -rf /tmp/post-install
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER"
USER "$NEW_USER"
RUN cd dotfiles && make tui
CMD ["/bin/zsh"]

