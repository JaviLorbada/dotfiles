# .dotfiles [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/JaviLorbada/dotfiles/blob/master/LICENSE)

Modern terminal dotfiles with zsh configuration, modern CLI tools, and sensible defaults.

## Features

- **Modern ZSH Configuration**: Enhanced oh-my-zsh setup with useful plugins
- **Modern CLI Tools**: Replacements for traditional Unix tools (eza, bat, fd, ripgrep, etc.)
- **Smart Navigation**: zoxide for intelligent directory jumping
- **Fuzzy Finding**: fzf for command history and file search
- **Git Integration**: Comprehensive git aliases and enhanced status display
- **macOS Optimized**: Finder shortcuts and system utilities
- **Secure**: Local secrets management with .zshrc.local

## Quick Start

### Prerequisites

1. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install oh-my-zsh**:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/JaviLorbada/dotfiles ~/Documents/Workspace/dotfiles
   cd ~/Documents/Workspace/dotfiles
   ```

2. **Install modern CLI tools**:
   ```bash
   brew install eza fzf zoxide bat fd ripgrep fnm git-flow
   ```

3. **Install zsh plugins**:
   ```bash
   # Autosuggestions
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

   # Syntax highlighting
   git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

4. **Install Nerd Fonts** (required for icons in `eza`):
   ```bash
   brew install --cask font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-meslo-lg-nerd-font
   ```

5. **Run the install script**:
   ```bash
   ./install.sh
   ```

6. **Configure your terminal to use a Nerd Font**:

   **For Ghostty (Recommended):**
   - Configuration is automatic! The install script links the config from `.config/ghostty/`
   - Default font: JetBrainsMono Nerd Font at size 14
   - To customize, edit `~/.config/ghostty/config`
   - Restart Ghostty to apply changes
   - Key features enabled: shell integration, Option-as-Alt, 50k scrollback

   **For iTerm2:**
   - Press `Cmd + ,` to open Preferences
   - Go to Profiles → Text
   - Click "Change Font" and select one of:
     - **JetBrainsMono Nerd Font** (recommended)
     - **FiraCode Nerd Font** (with ligatures)
     - **MesloLGS NF**
   - Choose size 13-14
   - Optionally enable "Use ligatures" for FiraCode

   **For macOS Terminal:**
   - Terminal → Settings → Profiles
   - Select your profile → Text tab
   - Click "Change" next to Font
   - Select a Nerd Font from the list

   **For other terminals:** Look for font settings and select any Nerd Font.

7. **Set up local secrets** (optional):
   ```bash
   cp .zshrc.local.template ~/.zshrc.local
   # Edit ~/.zshrc.local with your API tokens and secrets
   ```

8. **Configure Git** (update `~/.gitconfig` with your details):
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

9. **Reload your shell**:
   ```bash
   source ~/.zshrc
   ```

## What's Included

### Modern CLI Tools

- **eza**: Modern replacement for `ls` with git integration and icons (requires Nerd Font)
- **bat**: Better `cat` with syntax highlighting
- **fd**: Faster, user-friendly alternative to `find`
- **ripgrep (rg)**: Faster grep alternative
- **fzf**: Fuzzy finder for command history and files
- **zoxide**: Smart directory navigation (tracks your most-used directories)
- **fnm**: Fast Node.js version manager

### ZSH Plugins

- **git**: Git aliases and functions
- **zsh-autosuggestions**: Fish-like autosuggestions
- **zsh-syntax-highlighting**: Command syntax highlighting
- **docker**: Docker completions
- **kubectl**: Kubernetes completions
- **npm**: NPM completions
- **macos**: macOS-specific utilities

### Key Features

#### Enhanced History
- 50,000 command history with timestamps
- Shared history across all terminal sessions
- Duplicate removal and smart search

#### Directory Navigation
- `z <partial-path>`: Jump to frequently used directories
- `d`: Show directory stack
- `cdg`: Jump to git repository root
- `..` and `...`: Quick parent directory navigation

#### Git Shortcuts
- `g`: git
- `gs`: git status
- `gco`: git checkout
- `gcb`: git checkout -b
- `glog`: Beautiful git log graph
- And many more!

#### Modern Aliases
- `l`: List files with eza (icons + git status)
- `la`: List all files including hidden
- `lt`: Tree view
- `cat`: Uses bat with syntax highlighting
- `cd`: Uses zoxide for smart navigation

#### macOS Utilities
- `show`/`hide`: Toggle hidden files in Finder
- `showdesktop`/`hidedesktop`: Toggle desktop icons
- `ports`: Show listening ports
- `flush`: Flush DNS cache

## Optional Enhancements

### Powerlevel10k Theme (Recommended)

For a modern, fast, and beautiful prompt:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Then update `~/.zshrc`:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Run `p10k configure` to set up your prompt.

### Additional Software

Check out [software.md](software.md) for recommended applications and tools.

## File Structure

```
.
├── .config/
│   └── ghostty/
│       └── config            # Ghostty terminal configuration
├── .zshrc                    # Main ZSH configuration
├── .zshrc.local.template     # Template for local secrets
├── .gitconfig                # Git configuration
├── .gitignore                # Files to ignore in repo
├── .aliases                  # Additional aliases (legacy)
├── install.sh                # Installation script
├── README.md                 # This file
└── software.md               # Recommended software list
```

## Customization

### Local Configuration

Create `~/.zshrc.local` for machine-specific settings that shouldn't be committed:

```bash
# API tokens
export GITHUB_TOKEN=your_token_here

# Local paths
export CUSTOM_PATH=/path/to/something

# Machine-specific aliases
alias work="cd ~/Work/projects"
```

### Adding Your Own Aliases

Edit `~/.zshrc` or add them to `~/.zshrc.local` for local-only aliases.

## Updating

To update your dotfiles:

```bash
cd ~/Documents/Workspace/dotfiles
git pull origin master
source ~/.zshrc
```

## Security Note

**IMPORTANT**: Never commit API tokens, passwords, or other secrets to the repository. Always use `~/.zshrc.local` for sensitive information, which is automatically excluded from git.

## Legacy Files

Some legacy bash files are included for compatibility but are no longer actively maintained:
- `.bash_profile`
- `.bashrc`
- `.bash_prompt`

## Troubleshooting

### Icons not showing in eza/ls output?

If you see `--` or boxes instead of proper file/folder icons:

1. **Install a Nerd Font** (if not already done):
   ```bash
   brew install --cask font-jetbrains-mono-nerd-font
   ```

2. **Configure your terminal** to use the Nerd Font:
   - Ghostty: Edit `~/.config/ghostty/config` and set `font-family`
   - iTerm2: `Cmd + ,` → Profiles → Text → Change Font
   - Terminal: Settings → Profiles → Text → Font
   - Select "JetBrainsMono Nerd Font" or any other Nerd Font

3. **Restart your terminal** completely (close all tabs/windows)

4. **Test**: Run `l` and you should see proper icons 📁 📄 🔧

### Plugins not loading?

Make sure you've cloned the plugin repositories and they're in the correct location:
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

### Modern tools not working?

Check they're installed:
```bash
brew list | grep -E "eza|fzf|zoxide|bat|fd|ripgrep"
```

### Symlinks not working?

Re-run the install script:
```bash
cd ~/Documents/Workspace/dotfiles
./install.sh
```

## Contact

- [Javi Lorbada](mailto:javi@javilorbada.com)
- Follow [@javilorbada](https://twitter.com/javilorbada) on Twitter
- https://javilorbada.com/

## License

MIT License - see [LICENSE](LICENSE) for details.
