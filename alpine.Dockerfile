FROM docker:19 as docker

FROM alpine:edge
ARG NEW_USER="ntrrg"
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge"
RUN \
  echo "$MIRROR/main" > /etc/apk/repositories && \
  echo "$MIRROR/community" >> /etc/apk/repositories && \
  apk update && apk upgrade -f && \
  apk add sudo && \
  adduser -s "/bin/zsh" -D "$NEW_USER" && \
  echo "$NEW_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
WORKDIR "/tmp/post-install"
COPY post-install-alpine.sh .
RUN \
  BASEPATH="/tmp/post-install" IS_CONTAINER=1 IS_GUI=0 IS_HARDWARE=0 \
  /tmp/post-install/post-install-alpine.sh && \
  cd / && rm -rf /tmp/post-install
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" dotfiles
USER "$NEW_USER":"$NEW_USER"
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

