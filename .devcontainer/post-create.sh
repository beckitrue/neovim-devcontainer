#!/bin/bash

# Post-create script for Neovim devcontainer setup
set -e

echo "🚀 Setting up development environment..."

# Create necessary directories
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.aws
mkdir -p ~/.ssh

# Apply user dotfiles if DOTFILES_REPO is set
if [ -n "${DOTFILES_REPO}" ]; then
    echo "📦 Applying dotfiles from ${DOTFILES_REPO}..."

    # Clone dotfiles repository
    if [ ! -d ~/dotfiles ]; then
        git clone "${DOTFILES_REPO}" ~/dotfiles
    fi

    # Backup and remove base config if dotfiles will provide nvim config
    if [ -d ~/dotfiles/nvim ]; then
        echo "📝 Backing up base Neovim config..."
        if [ -d ~/.config/nvim ]; then
            rm -rf ~/.config/nvim.bak
            mv ~/.config/nvim ~/.config/nvim.bak
        fi
    fi

    # Run install command if specified
    if [ -n "${DOTFILES_INSTALL_CMD}" ]; then
        cd ~/dotfiles
        if [ -f "${DOTFILES_INSTALL_CMD}" ]; then
            bash "${DOTFILES_INSTALL_CMD}"
        elif [ -f "install.sh" ]; then
            bash install.sh
        else
            # If no install script, try using stow for common directories
            if command -v stow &> /dev/null; then
                for dir in nvim tmux zsh git starship; do
                    if [ -d "$dir" ]; then
                        echo "Stowing $dir..."
                        stow --target="$HOME/.config" --restow "$dir" || true
                    fi
                done
            fi
        fi
        cd -
    fi
else
    # Only setup base config if no dotfiles provided
    echo "📝 Setting up base Neovim configuration..."
    mkdir -p ~/.config/nvim/lua/plugins
    cp -r .devcontainer/base-config/nvim/* ~/.config/nvim/
fi

# Install Python dependencies if present
if [ -f "requirements.txt" ]; then
    echo "🐍 Installing Python dependencies..."
    python3.11 -m pip install -r requirements.txt
elif [ -f "Pipfile" ]; then
    echo "🐍 Installing Python dependencies with Pipenv..."
    pipenv install
elif [ -f "pyproject.toml" ]; then
    echo "🐍 Installing Python dependencies with Poetry..."
    poetry install
fi

# Install Node dependencies if present
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
fi

# Note: Go support has been removed to reduce image size
# To add Go support, install it locally in the container

# Configure Git if not already configured
if [ -z "$(git config --global user.email)" ]; then
    echo "📝 Git user.email not configured. Set it with:"
    echo "  git config --global user.email 'you@example.com'"
fi

if [ -z "$(git config --global user.name)" ]; then
    echo "📝 Git user.name not configured. Set it with:"
    echo "  git config --global user.name 'Your Name'"
fi

# Set up AWS CLI configuration if credentials are provided
if [ -n "${AWS_ACCESS_KEY_ID}" ] && [ -n "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "☁️ Configuring AWS CLI..."
    aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
    aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
    [ -n "${AWS_DEFAULT_REGION}" ] && aws configure set default.region "${AWS_DEFAULT_REGION}"
fi

# Set up Cloudflare Wrangler if token is provided
if [ -n "${CLOUDFLARE_API_TOKEN}" ]; then
    echo "☁️ Cloudflare API token detected. You can now use 'wrangler' commands."
fi

# Install Neovim plugins
echo "📦 Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa || true

# Create a workspace information file
cat > ~/.devcontainer-info << EOF
🚀 Neovim Development Container

Installed Tools:
- Neovim (with lazy.nvim)
- Languages: Python 3.11, Node.js/TypeScript
- Cloud: AWS CLI, Cloudflare Wrangler
- Database: PostgreSQL client
- Terminal: tmux, ripgrep, fzf, starship

Quick Commands:
- nvim: Open Neovim
- tmux: Start terminal multiplexer
- aws: AWS CLI commands
- wrangler: Cloudflare Workers CLI
- python3.11: Python interpreter
- node/npm: Node.js runtime
- psql: PostgreSQL client

Configuration Files:
- Neovim: ~/.config/nvim/
- AWS: ~/.aws/
- Git: ~/.gitconfig
- Tmux: ~/.tmux.conf

To configure claude-code.nvim:
1. Ensure claude-code CLI is installed
2. Open Neovim and run :Lazy to check plugin status
3. Use <C-,> to toggle Claude Code

EOF

echo "✅ Development environment setup complete!"
echo "📋 Run 'cat ~/.devcontainer-info' to see available tools and commands"