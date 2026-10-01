# An Ubuntu container set up with this repo (shell, Neovim, tmux), via
# setup-shell-debian.bash:
#   docker build -f shell/setup-shell-ubuntu.Dockerfile -t dojo .
#   docker run -it dojo
FROM ubuntu:24.04

ENV USER=thomasian06
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y -qq git sudo ca-certificates && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash ${USER} && passwd -d ${USER} && usermod -aG sudo ${USER}
USER ${USER}
WORKDIR /home/${USER}

COPY --chown=${USER} . /home/${USER}/projects/dojo
RUN /home/${USER}/projects/dojo/shell/setup-shell-debian.bash
CMD ["zsh", "-l"]
