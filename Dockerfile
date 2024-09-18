FROM alpine:edge
ARG NEW_USER="ntrrg"
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge"
WORKDIR "/tmp/post-install"
COPY post-install.sh .
RUN \
  echo "$MIRROR/main" > /etc/apk/repositories && \
  echo "$MIRROR/community" >> /etc/apk/repositories && \
  echo "@testing $MIRROR/testing" >> /etc/apk/repositories && \
  apk update && apk upgrade alpine-keys && apk upgrade --available && \
  apk add doas && \
  echo "permit nopass $NEW_USER as root" >> /etc/doas.d/doas.conf && \
  sudo true && \
  NEW_USER="$NEW_USER" IS_HARDWARE=0 /tmp/post-install/post-install.sh && \
  cd / && rm -rf /tmp/post-install
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER"
USER "$NEW_USER"
RUN cd dotfiles && make tui
CMD ["/bin/zsh"]

