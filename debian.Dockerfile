FROM debian:bookworm-slim
ARG NEW_USER="ntrrg"
ARG MIRROR="http://deb.debian.org/debian"
COPY post-install-debian.sh .
RUN \
  echo "deb $MIRROR bookworm main contrib" > "/etc/apt/sources.list" && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y busybox && \
  ln -sf "$(command -v busybox)" "$(command -v sh)" && \
  apt-get install -y sudo && \
  echo "\n$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> "/etc/sudoers" && \
  DEBIAN_FRONTEND="noninteractive" \
  IS_HARDWARE=0 NEW_USER="$NEW_USER" "/post-install-debian.sh" && \
  rm -f "/post-install-debian.sh"
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER"
USER "$NEW_USER"
RUN cd "dotfiles" && make tui && cd .. && rm -rf "dotfiles"
CMD ["/bin/zsh"]
