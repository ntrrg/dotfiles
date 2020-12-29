FROM alpine:edge
ARG NEW_USER="ntrrg"
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge"
WORKDIR "/tmp/post-install"
COPY post-install.sh .
RUN \
  echo "$MIRROR/main" > /etc/apk/repositories && \
  echo "$MIRROR/community" >> /etc/apk/repositories && \
  echo "$MIRROR/testing" >> /etc/apk/repositories && \
  apk update && apk upgrade && \
  apk add sudo && \
  echo "$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  BASEPATH="/tmp/post-install" NEW_USER="$NEW_USER" IS_GUI=0 IS_HARDWARE=0 \
  /tmp/post-install/post-install.sh && \
  cd / && rm -rf /tmp/post-install
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" dotfiles
USER "$NEW_USER"
RUN cd dotfiles && make tui
CMD ["/bin/zsh"]

