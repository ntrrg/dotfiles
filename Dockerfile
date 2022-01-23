FROM alpine:3.15
ARG NEW_USER="ntrrg"
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/v3.15"
WORKDIR "/tmp/post-install"
COPY post-install.sh .
RUN \
  echo "$MIRROR/main" > /etc/apk/repositories && \
  echo "$MIRROR/community" >> /etc/apk/repositories && \
  ([ "${MIRROR##*/}" = "edge" ] && echo "$MIRROR/testing" >> /etc/apk/repositories || true) && \
  apk update && apk upgrade alpine-keys && apk upgrade --available && \
  apk add doas docs lang && \
  echo "permit nopass $NEW_USER as root" >> /etc/doas.conf && \
  BASEPATH="/tmp/post-install" NEW_USER="$NEW_USER" IS_GUI=0 IS_HARDWARE=0 \
  /tmp/post-install/post-install.sh && \
  cd / && rm -rf /tmp/post-install
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER"
USER "$NEW_USER"
RUN cd dotfiles && make tui
CMD ["/bin/zsh"]

