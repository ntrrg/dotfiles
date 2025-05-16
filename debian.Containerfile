FROM debian:bookworm-slim
ARG MIRROR="http://deb.debian.org/debian"
COPY post-install-debian.sh .
RUN \
  echo "deb $MIRROR bookworm main contrib" > "/etc/apt/sources.list" && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y busybox && \
  ln -sf "$(command -v busybox)" "$(command -v sh)" && \
  DEBIAN_FRONTEND="noninteractive" IS_HARDWARE=0 "/post-install-debian.sh" && \
  rm -f "/post-install-debian.sh"
WORKDIR "/root"
COPY . dotfiles
RUN cd "dotfiles" && make tui && cd .. && rm -rf "dotfiles"
CMD ["/bin/zsh"]
