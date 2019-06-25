FROM debian:buster-slim
ARG NEW_USER="ntrrg"
ARG NEW_USER_PASSWORD="1234"
RUN \
  echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y sudo && \
  useradd --shell "/bin/zsh" --create-home "$NEW_USER" && \
  echo "$NEW_USER:$NEW_USER_PASSWORD" | chpasswd && \
  usermod -aG sudo "$NEW_USER"
USER "$NEW_USER":"$NEW_USER"
WORKDIR "/home/$NEW_USER"
COPY post-install.sh dotfiles/
RUN \
  echo "$NEW_USER_PASSWORD\n" | sudo -S -- \
  DEBIAN_FRONTEND="noninteractive" GUI_ENABLED=0 CONTAINER=1 HARDWARE=0 \
  dotfiles/post-install.sh
COPY . dotfiles
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

