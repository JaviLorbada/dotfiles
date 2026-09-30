# .dotfiles [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/JaviLorbada/dotfiles/blob/main/LICENSE)

Modern terminal dotfiles with zsh configuration, modern CLI tools, and sensible defaults.

## Features

- **Modern ZSH Configuration**: Enhanced oh-my-zsh setup with useful plugins
- **Modern CLI Tools**: Replacements for traditional Unix tools (eza, bat, fd, ripgrep, etc.)
- **Smart Navigation**: zoxide for intelligent directory jumping
- **Fuzzy Finding**: fzf for command history and file search
- **Git Integration**: Comprehensive git aliases and enhanced status display
- **macOS Optimized**: Finder shortcuts and system utilities
- **Secure**: Local secrets management with .zshrc.local
- **Codex Skills**: Repo-managed Codex skills installed into `~/.codex/skills`

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
   brew install eza fzf zoxide bat fd ripgrep fnm git-flow xcdiff
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

   This also links any skill stored under `skills/` into `~/.codex/skills/`.

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
- **xcdiff**: Semantic diff for `.xcodeproj` files

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
- `xpd`: Compare `.xcodeproj` across refs with xcdiff
- `xpdv`: Same as `xpd` with verbose output
- `xph`: Generate an HTML side-by-side xcodeproj diff report
- `xpdiff`: Same as `git xpdiff`
- `xpdiffv`: Same as `git xpdiffv`
- `xphtml`: Same as `git xphtml`
- And many more!

#### Xcode Project Diff Workflow
- `git xpdiff [ref1] [ref2] [path/to/App.xcodeproj]`: semantic compare (defaults to `HEAD~1` vs `HEAD`)
- `git xpdiffv [ref1] [ref2] [path/to/App.xcodeproj]`: verbose semantic compare
- `git xphtml [ref1] [ref2] [path/to/App.xcodeproj]`: writes a side-by-side HTML report to a temp file and prints its path
- `git-xcdiff [ref1] [ref2] [path/to/App.xcodeproj]`: direct helper command installed at `~/.local/bin/git-xcdiff`
- `git xptags`: list available xcdiff comparator tags
- Regular inline file diff for `project.pbxproj` is improved through a dedicated Git diff driver.

#### Developer Disk Cleanup (`devclean`)

Xcode, simulators and package managers quietly fill the disk: the Xcode compilation cache alone can grow by tens of GB in a few weeks. `devclean` shows where that space went and reclaims it. Everything it deletes is rebuilt or downloaded again when needed; the cost is slower first builds.

- `devclean`: report only, nothing is deleted. Every item is listed with where it looks, and `none` when it finds nothing
- `devclean --run`: delete the reported items (asks first; refuses while Xcode or Simulator is open)
- `devclean --run --skip swiftpm-cache,homebrew`: leave some items alone
- `devclean --help`: list every item it covers

It covers Xcode DerivedData (including the compilation cache), simulators whose iOS version is gone, the physical device install cache, SwiftPM's cache and `.build` folders, Xcode `build` folders left by `xcodebuild`, Gradle `build` folders, npm, Homebrew, and CocoaPods/Carthage/Sourcery/Playwright/JetBrains Toolbox caches. It never touches Archives, working simulators, simulator runtimes, build folders tracked in git, or anything outside your home folder.

The report also lists what `--run` never deletes but is worth a look: installed Xcodes (with the selected one marked, since each Xcode keeps its own compilation cache) and simulator runtimes (size, last used, simulator count). Runtimes unused for 90+ days or without simulators are flagged with the command to remove them yourself.

A `build` folder only counts when it's clearly build output: next to a Gradle build file, or next to an Xcode project or `Package.swift` *and* holding Xcode's build output (`XCBuildData`, `*.build`, `*-iphoneos`...). Other folders that happen to be called `build` are left alone.

Build folders are searched for in `~/Developer`, `~/Documents/Workspace` and `~/Projects`. Point it elsewhere with `--projects ~/code:~/work` or `export DEVCLEAN_PROJECT_DIRS=~/code:~/work`.

`devclean` is a single self-contained script with no dependency on the rest of these dotfiles. To use it without installing them:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/JaviLorbada/dotfiles/main/bin/devclean -o ~/.local/bin/devclean
chmod +x ~/.local/bin/devclean
```

(`~/.local/bin` must be on your `PATH`; otherwise run it as `~/.local/bin/devclean`.)

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
├── bin/
│   └── devclean              # Developer cache cleanup, linked into ~/.local/bin
├── skills/
│   └── <skill-name>/         # Codex skills linked into ~/.codex/skills
├── .zshrc                    # Main ZSH configuration
├── .zshrc.local.template     # Template for local secrets
├── .git-xcdiff               # Helper script used by git xpdiff aliases
├── .gitconfig                # Git configuration
├── .gitignore                # Files to ignore in repo
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

### Adding Codex Skills

Add a skill under `skills/<skill-name>/` and rerun `./install.sh`.

The installer will:

- create `~/.codex/skills` if needed
- symlink each repo-managed skill into `~/.codex/skills/<skill-name>`
- back up an existing non-symlink skill directory before replacing it

## Updating

To update your dotfiles:

```bash
cd ~/Documents/Workspace/dotfiles
git pull origin main
source ~/.zshrc
```

## Security Note

**IMPORTANT**: Never commit API tokens, passwords, or other secrets to the repository. Always use `~/.zshrc.local` for sensitive information, which is automatically excluded from git.

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
brew list | grep -E "eza|fzf|zoxide|bat|fd|ripgrep|xcdiff"
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
