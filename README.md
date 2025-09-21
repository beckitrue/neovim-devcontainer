# Neovim Full-Stack Development Container

A comprehensive development container featuring Neovim with lazy.nvim, claude-code.nvim integration, and support for multiple programming languages and cloud tools.

## Features

### Editor & AI
- **Neovim** (latest stable) with **lazy.nvim** package manager
- **Claude Code CLI** - AI coding assistant that understands your codebase
- **claude-code.nvim** - Neovim integration for Claude Code
- Pre-configured with essential plugins (Telescope, Treesitter, LSP support)
- Customizable through personal dotfiles

### Languages & Runtimes
- **Python** (3.11) with pip, virtualenv, pipenv, poetry, black, flake8, mypy
- **Node.js** (LTS) with npm
- **TypeScript** with ts-node and type definitions

### Cloud & DevOps Tools
- **AWS CLI v2** - Amazon Web Services command-line interface
- **Cloudflare Wrangler** - Deploy and manage Cloudflare Workers
- **Docker-in-Docker** - Build and run containers within the devcontainer
- **PostgreSQL Client** (psql) - Database management

### Terminal Tools
- **tmux** - Terminal multiplexer
- **ripgrep** - Fast recursive search
- **fzf** - Fuzzy finder
- **starship** - Cross-shell prompt
- **stow** - Symlink farm manager (for dotfiles)
- **git** - Version control

## Quick Start

### Prerequisites
- Docker Desktop or Docker Engine
- Git
- (Optional) Visual Studio Code with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Setup Options

#### Option A: Using Docker Compose (Standalone - No VS Code Required)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/neovim-devcontainer.git
   cd neovim-devcontainer
   ```

2. **Copy and configure environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your settings (dotfiles, AWS, etc.)
   ```

3. **Start the container:**
   ```bash
   # Build and run with docker-compose
   docker-compose up -d
   docker-compose exec neovim-dev bash

   # Or run in one command
   docker-compose run --rm neovim-dev
   ```

4. **Open Neovim:**
   ```bash
   nvim
   ```

#### Option B: Using VS Code Dev Containers

1. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/neovim-devcontainer.git
   cd neovim-devcontainer
   ```

2. **Copy and configure environment variables (optional):**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. **Open in VS Code:**
   ```bash
   code .
   ```

4. **Start the devcontainer:**
   - Press `F1` and select "Dev Containers: Reopen in Container"
   - Or click the green button in the bottom-left corner and select "Reopen in Container"

5. **Wait for the container to build** (first time may take 5-10 minutes)

6. **Open Neovim:**
   ```bash
   nvim
   ```

#### Option C: Using Plain Docker

1. **Clone and build:**
   ```bash
   git clone https://github.com/your-username/neovim-devcontainer.git
   cd neovim-devcontainer
   docker build -t neovim-dev .devcontainer/
   ```

2. **Run the container:**
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -w /workspace \
     neovim-dev \
     bash
   ```

3. **Inside the container, run setup and start Neovim:**
   ```bash
   bash .devcontainer/post-create.sh
   nvim
   ```

## Configuration

### Personal Dotfiles

This devcontainer supports automatic dotfiles installation for personalization. You have three options:

#### Option 1: VS Code User Settings (Recommended)
Add to your VS Code user settings (`~/.config/Code/User/settings.json`):

```json
{
  "dotfiles.repository": "https://github.com/your-username/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

#### Option 2: Project-specific Configuration
Uncomment and modify in `.devcontainer/devcontainer.json`:

```json
"dotfiles": {
  "repository": "https://github.com/beckitrue/dotfiles",
  "targetPath": "~/dotfiles",
  "installCommand": "install.sh"
}
```

#### Option 3: Environment Variables
Set in `.devcontainer/.env`:

```bash
DOTFILES_REPO=https://github.com/your-username/dotfiles
DOTFILES_INSTALL_CMD=install.sh
```

### Cloud Services Configuration

#### AWS CLI
Add to `.devcontainer/.env`:
```bash
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=us-east-1
```

Or mount your local AWS credentials:
```json
// Add to devcontainer.json mounts
"mounts": [
  "source=${localEnv:HOME}/.aws,target=/home/vscode/.aws,type=bind,consistency=cached"
]
```

#### Cloudflare Wrangler
Add to `.devcontainer/.env`:
```bash
CLOUDFLARE_API_TOKEN=your_api_token
CLOUDFLARE_ACCOUNT_ID=your_account_id
```

### Claude Code Integration

Claude Code CLI is pre-installed in the container. The claude-code.nvim plugin is also pre-configured.

#### First-time Setup:

1. **Verify installation:**
   ```bash
   claude-code --version
   # Or check with:
   claude doctor
   ```

2. **Authenticate Claude Code:**
   ```bash
   # You'll need either:
   # - Active billing at console.anthropic.com
   # - Or a Claude Pro/Max subscription

   claude login
   ```

3. **Use in Terminal:**
   ```bash
   # Ask Claude for help
   claude "explain this codebase"

   # Have Claude execute tasks
   claude "fix the failing tests"

   # Git workflow assistance
   claude "create a PR for this feature"
   ```

4. **Use in Neovim:**
   - `Ctrl+,` - Toggle Claude Code terminal
   - `<leader>cc` - Open Claude Code
   - `<leader>ct` - Toggle Claude Code
   - `<leader>cs` - Send visual selection to Claude

#### If Installation Fails:

If claude-code isn't installed during build, install it manually:
```bash
sudo npm install -g @anthropic-ai/claude-code
```

#### Updates:

Claude Code automatically updates itself. To manually update:
```bash
claude update
```

## Neovim Usage

### Pre-installed Plugins
- **lazy.nvim** - Plugin manager
- **claude-code.nvim** - AI coding assistant
- **telescope.nvim** - Fuzzy finder
- **nvim-treesitter** - Syntax highlighting
- **nvim-tree** - File explorer
- **gitsigns.nvim** - Git integration
- **lualine.nvim** - Status line
- **Comment.nvim** - Easy commenting
- **which-key.nvim** - Keybinding helper

### Key Mappings
- `<Space>` - Leader key
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>e` - Toggle file tree
- `<C-p>` - Git files
- `<leader>y` - Yank to system clipboard
- `<leader>p` - Paste without yanking

### Managing Plugins
```vim
:Lazy          " Open lazy.nvim UI
:Lazy sync     " Install/update plugins
:Lazy clean    " Remove unused plugins
```

## Development Workflows

### Python Development
```bash
# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Or use Poetry
poetry install
poetry shell
```


### TypeScript/Node.js Development
```bash
# Install dependencies
npm install

# Run TypeScript directly
ts-node src/index.ts

# Build TypeScript
tsc

# Use Wrangler for Cloudflare Workers
wrangler dev
wrangler deploy
```

### Database Access
```bash
# Connect to PostgreSQL
psql -h hostname -U username -d database

# Set connection via environment
export PGHOST=localhost
export PGUSER=postgres
export PGPASSWORD=password
psql
```

## Customization

### Adding VS Code Extensions
Edit `.devcontainer/devcontainer.json`:
```json
"customizations": {
  "vscode": {
    "extensions": [
      "your.extension-id"
    ]
  }
}
```

### Adding System Packages
Edit `.devcontainer/Dockerfile`:
```dockerfile
RUN apt-get update && apt-get install -y \
    your-package-name
```

### Adding Neovim Plugins
Create `~/.config/nvim/lua/plugins/custom.lua`:
```lua
return {
  {
    "plugin/name",
    config = function()
      -- Configuration here
    end
  }
}
```

## Troubleshooting

### Container Build Issues
- Ensure Docker is running
- Check Docker has sufficient resources (RAM/Disk)
- Try rebuilding: `Dev Containers: Rebuild Container`

### Neovim Plugin Issues
```vim
:Lazy sync     " Reinstall plugins
:checkhealth   " Check Neovim health
:messages      " View error messages
```

### Permission Issues
- The container runs as user `vscode` (UID 1000)
- Use `sudo` for system-level operations
- Check file ownership: `ls -la`

### Slow Performance
- Increase Docker memory allocation
- Disable unnecessary VS Code extensions
- Use bind mounts sparingly

### Claude Code Not Working
- Verify claude-code CLI is installed and in PATH
- Check API key configuration
- Review plugin logs: `:messages`

## Project Structure

```
.devcontainer/
├── devcontainer.json      # VS Code container configuration
├── Dockerfile             # Container image definition
├── post-create.sh        # Post-creation setup script
├── .env.example          # Environment variables template
└── base-config/
    └── nvim/             # Base Neovim configuration
        ├── init.lua
        └── lua/
            └── plugins/
                ├── claude-code.lua
                └── core.lua
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in the devcontainer
5. Submit a pull request

## References

- [Dev Containers Specification](https://containers.dev/)
- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [claude-code.nvim](https://github.com/greggh/claude-code.nvim)
- [beckitrue/dotfiles](https://github.com/beckitrue/dotfiles)
- [beckitrue/devpod-neovim](https://github.com/beckitrue/devpod-neovim)

## License

MIT License - See LICENSE file for details

## Acknowledgments

- Inspired by [beckitrue/devpod-neovim](https://github.com/beckitrue/devpod-neovim)
- claude-code.nvim by [greggh](https://github.com/greggh)
- The Neovim and Dev Containers communities