FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install base development tools with retry logic
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --fix-missing && \
    apt-get -y install --no-install-recommends \
    build-essential \
    curl \
    git \
    wget \
    software-properties-common \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add repositories and install packages (except Neovim)
RUN add-apt-repository ppa:deadsnakes/ppa && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
    stow \
    ripgrep \
    fzf \
    tmux \
    jq \
    unzip \
    zip \
    htop \
    zsh \
    postgresql-client \
    nodejs \
    python3.11 \
    python3.11-venv \
    python3-pip \
    python3.11-dev \
    fuse \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install latest Neovim from official releases
RUN mkdir -p /opt && \
    curl -fsSL --retry 3 https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz && \
    chmod +x /opt/nvim-linux-x86_64/bin/nvim && \
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim-linux-x86_64.tar.gz && \
    nvim --version

# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# Install Node.js global packages
RUN npm install -g \
    wrangler@latest \
    typescript \
    ts-node \
    @types/node \
    @anthropic-ai/claude-code

# Install Python tools and AWS CLI
RUN python3.11 -m pip install --upgrade pip \
    && python3.11 -m pip install \
    awscli \
    virtualenv \
    pipenv \
    poetry \
    black \
    flake8 \
    mypy

# Claude Code CLI is installed via npm above

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set up non-root user (if not already provided by base image)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user if it doesn't exist
RUN id -u $USERNAME 2>/dev/null || useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Pre-install lazy.nvim for the user
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable \
    ~/.local/share/nvim/lazy