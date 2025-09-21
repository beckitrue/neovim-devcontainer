FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install base development tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    curl \
    git \
    wget \
    software-properties-common \
    gnupg2 \
    lsb-release \
    ca-certificates

# Install Neovim (latest stable)
RUN add-apt-repository ppa:neovim-ppa/stable \
    && apt-get update \
    && apt-get -y install neovim

# Install terminal tools
RUN apt-get -y install --no-install-recommends \
    stow \
    ripgrep \
    fzf \
    tmux \
    jq \
    unzip \
    zip \
    htop

# Install PostgreSQL client
RUN apt-get -y install --no-install-recommends postgresql-client

# Install Starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

# Install Node.js (for TypeScript and Wrangler)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Python 3.11 and pip
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get -y install python3.11 python3.11-venv python3-pip python3.11-dev

# Install Node.js global packages
RUN npm install -g \
    wrangler@latest \
    typescript \
    ts-node \
    @types/node

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

# Install claude-code CLI (placeholder - update with actual release URL when available)
# Note: Replace this with the actual claude-code CLI installation when available
# RUN curl -fsSL https://github.com/anthropics/claude-code/releases/latest/download/claude-code-linux-x64 \
#     -o /usr/local/bin/claude-code \
#     && chmod +x /usr/local/bin/claude-code

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