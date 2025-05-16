FROM alpine:edge
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge"
COPY post-install.sh .
RUN \
  echo "$MIRROR/main" > "/etc/apk/repositories" && \
  echo "$MIRROR/community" >> "/etc/apk/repositories" && \
  echo "@testing $MIRROR/testing" >> "/etc/apk/repositories" && \
  apk update && apk upgrade alpine-keys && apk upgrade --available && \
  IS_HARDWARE=0 "/post-install.sh" && \
  rm -f "/post-install.sh"
WORKDIR "/root"
COPY . dotfiles
RUN cd "dotfiles" && make tui && cd .. && rm -rf "dotfiles"
CMD ["/bin/zsh"]
