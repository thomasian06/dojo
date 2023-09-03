FROM ubuntu:latest

ENV USER=thomasian06
ENV DEBIAN_FRONTEND=noninteractive

# User configuration
RUN apt install git zsh -y
RUN useradd -ms /bin/zsh ${USER}
RUN passwd -d ${USER}
RUN usermod -aG sudo ${USER}
USER ${USER}

# Terminal Configuration
WORKDIR /home/${USER}
RUN mkdir .fonts
WORKDIR /home/${USER}/.fonts
RUN curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf && \
    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf && \
    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf && \
    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

WORKDIR /home/${USER}
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/olets/zsh-abbr.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-abbr

RUN git clone https://github.com/thomasian06/dojo.git /home/${USER}/.dojo
WORKDIR /home/${USER}/.dojo/shell
RUN cp .p10k.zsh .zprofile .zsh_aliases .zshrc /home/${USER}/
WORKDIR /home/${USER}