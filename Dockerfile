FROM debian:buster-slim
RUN useradd --shell "/bin/zsh" ntrrg
WORKDIR /hone/ntrrg/
COPY . ./dotfiles
RUN \
  echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list && \
  MODE="text" dotfiles/post-install.sh
USER ntrrg:ntrrg
RUN cd dotfiles && make bin git vim zsh
CMD ["/bin/zsh"]

