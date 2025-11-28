# macOS Dev Environment — Setup Guide

This repository documents the step‑by‑step setup I use for a new MacBook Pro developer environment: iTerm2, Homebrew, Oh My Zsh, Powerlevel10k, Go, Node/TS, Docker, Kubernetes tools, and useful CLI utilities. Keep this repo as a single‑file reference and a place to store dotfiles and notes.

---

## Repository layout

* `README.md` — this file (setup steps + explanations)
* `dotfiles/` — (optional) symlinks, `.zshrc`, `p10k` config, aliases
* `iterm/` — (optional) exported iTerm2 preferences or tips
* `LICENSE` — license for your notes

---

## Quick goals

1. Provide an easily repeatable set of commands to bootstrap a fresh macOS install.
2. Save shell config and tips in `dotfiles/` to quickly apply on future machines.
3. Keep everything minimal and reproducible.

---

## 1 — Prerequisites

* A new or wiped macOS machine (Intel or Apple Silicon)
* Internet connection
* A GitHub account

---

## 2 — Configure Git and GitHub (SSH + CLI)

### 2.1 Install Git (via Homebrew)

```sh
# install Homebrew (if missing)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# then ensure brew in path (Apple Silicon example)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# install git
brew install git
```

### 2.2 Configure basic git settings

Replace the name/email with your own.

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
# recommended: use credential helper for GitHub CLI + token flow (gh will help)
git config --global core.autocrlf input
```

### 2.3 Generate an SSH key (recommended)

```sh
# default path; press enter to accept
ssh-keygen -t ed25519 -C "you@example.com"
# start the agent and add key
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
# copy to clipboard (macOS)
pbcopy < ~/.ssh/id_ed25519.pub
# then add to GitHub: https://github.com/settings/ssh/new
```

> If you prefer HTTPS, you can skip SSH and use `gh auth login` to authenticate.

### 2.4 Install GitHub CLI and log in

```sh
brew install gh
# login (interactive): choose HTTPS or SSH, follow prompts
gh auth login
# confirm identity
gh auth status
```

---

## 3 — Create the repository for this guide

**Option A — create repository remotely first (recommended)**

```sh
# create a local folder
mkdir -p ~/projects/macos-dev-setup
cd ~/projects/macos-dev-setup
# create initial files
cat > README.md <<'EOF'
# macOS Dev Environment — notes

Initial commit.
EOF
# initialize git
git init
git add README.md
git commit -m "chore: initial commit"
# create repo on GitHub and push
# replace USERNAME with your GitHub username if you want an explicit name
gh repo create macos-dev-setup --public --source=. --remote=origin --push
```

**Option B — create repo on GitHub.com first**

1. Go to `https://github.com/new` and create `macos-dev-setup` (public or private).
2. On your machine:

```sh
git clone git@github.com:USERNAME/macos-dev-setup.git
cd macos-dev-setup
# add files and push as usual
```

---

## 4 — Recommended initial content for the repo

* `README.md` (this file)
* `dotfiles/.zshrc` — include aliases, plugin sources, `p10k` source
* `dotfiles/p10k.zsh` — Powerlevel10k config
* `iterm/` — notes about fonts (MesloLGS NF), iTerm2 hotkey window, keybindings

Example `.gitignore` for dotfiles repo:

```
.DS_Store
node_modules/
.env
```

---

## 5 — Bootstrapping commands (one-liners you can run)

Below is a compact script you can copy‑paste to perform the basic install (modify to taste). **Read first** before running.

```sh
# === bootstrap.sh (run manually, read before execute) ===
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# add brew to path (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
# core tools
brew install --cask iterm2 docker
brew install git node go kubectl helm k9s fzf ripgrep zsh-autosuggestions zsh-syntax-highlighting
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# powerlevel10k
brew install romkatv/powerlevel10k/powerlevel10k
# final message
echo "BOOTSTRAP DONE — now run 'p10k configure' and 'gh auth login'"
```

---

## 6 — Storing dotfiles & creating symlinks (suggested workflow)

1. Create a `dotfiles` folder in the repo:

```sh
mkdir dotfiles
# move existing files
mv ~/.zshrc dotfiles/.zshrc  # if you already have it and want to save
# commit and push
git add dotfiles
git commit -m "chore: add dotfiles"
git push
```

2. Use symlinks to activate:

```sh
ln -s ~/projects/macos-dev-setup/dotfiles/.zshrc ~/.zshrc
ln -s ~/projects/macos-dev-setup/dotfiles/p10k.zsh ~/.p10k.zsh
```

---

## 7.5 — Install VS Code

### Install via Homebrew

```sh
brew install --cask visual-studio-code
```

### Recommended VS Code Extensions

* ms-vscode.go — Go support
* esbenp.prettier-vscode — Prettier
* dbaeumer.vscode-eslint — ESLint
* GitHub.copilot — GitHub Copilot (optional)
* GitHub.copilot-chat — Chat integration (optional)

### Recommended VS Code Settings Snippet

Add to `settings.json`:

```json
{
  "editor.formatOnSave": true,
  "go.toolsManagement.autoUpdate": true,
  "go.useLanguageServer": true,
  "[go]": {
    "editor.defaultFormatter": "golang.go"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

## 8 — Next steps / suggestions

* Add a `bootstrap.sh` to the repo and keep it idempotent.
* Add a short `INSTALL.md` with per‑section details (fonts, VSCode extensions, macOS settings).
* Export iTerm2 preferences (Preferences → General → Preferences → Save changes to folder) and add to the `iterm/` folder.

---

## LICENSE

Pick a license (MIT is typical for personal notes). Add a `LICENSE` file.

---

*End of guide — edit this file in the repo and keep it as your single source of truth.*
