FROM alpine:3.21
ARG NEW_USER="ntrrg"
ARG MIRROR="http://dl-cdn.alpinelinux.org/alpine/v3.21"
COPY post-install.sh .
RUN \
  echo "$MIRROR/main" > "/etc/apk/repositories" && \
  echo "$MIRROR/community" >> "/etc/apk/repositories" && \
  apk update && apk upgrade alpine-keys && apk upgrade --available && \
  apk add doas && \
  echo "permit nopass $NEW_USER as root" >> "/etc/doas.d/doas.conf" && \
  IS_HARDWARE=0 NEW_USER="$NEW_USER" "/post-install.sh" && \
  rm -f "/post-install.sh"
WORKDIR "/home/$NEW_USER"
COPY . dotfiles
RUN chown -R "$NEW_USER":"$NEW_USER" "/home/$NEW_USER"
USER "$NEW_USER"
RUN cd "dotfiles" && make tui && cd .. && rm -rf "dotfiles"
CMD ["/bin/zsh"]
