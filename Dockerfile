FROM debian:buster
RUN useradd --shell "/bin/zsh" --create-home ntrrg
COPY post-install.sh /bin/
RUN \
  echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list && \
  DEBIAN_FRONTEND="noninteractive" MODE="text" post-install.sh
USER ntrrg:ntrrg
WORKDIR /hone/ntrrg/
COPY . dotfiles
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

