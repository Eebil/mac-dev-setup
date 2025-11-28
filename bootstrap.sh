#!/bin/bash

# =============================================================================
# macOS Dev Environment Bootstrap Script
# =============================================================================
# This script sets up a fresh macOS machine with developer tools.
# Run: chmod +x bootstrap.sh && ./bootstrap.sh
# =============================================================================

set -e

echo " Starting macOS Dev Environment Bootstrap..."

# -----------------------------------------------------------------------------
# 1. Install Homebrew
# -----------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to path (Apple Silicon)
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# -----------------------------------------------------------------------------
# 2. Install CLI Tools
# -----------------------------------------------------------------------------
echo "🔧 Installing CLI tools..."
brew install git gh node go kubectl helm k9s

# -----------------------------------------------------------------------------
# 3. Install Zsh Plugins
# -----------------------------------------------------------------------------
echo "🐚 Installing Zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting

# -----------------------------------------------------------------------------
# 4. Install GUI Applications
# -----------------------------------------------------------------------------
echo "🖥️  Installing applications..."
brew install --cask iterm2 docker visual-studio-code

# -----------------------------------------------------------------------------
# 5. Install Oh My Zsh
# -----------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💅 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed"
fi

# -----------------------------------------------------------------------------
# 6. Install Powerlevel10k
# -----------------------------------------------------------------------------
echo "🎨 Installing Powerlevel10k..."
brew install romkatv/powerlevel10k/powerlevel10k

# Add Powerlevel10k to .zshrc if not already present
if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc 2>/dev/null; then
    echo 'source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
fi

# -----------------------------------------------------------------------------
# 7. Configure Git (if not already configured)
# -----------------------------------------------------------------------------
if [ -z "$(git config --global user.name)" ]; then
    echo "⚙️  Git user.name not set. Please configure manually:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"you@example.com\""
fi

git config --global core.autocrlf input

# -----------------------------------------------------------------------------
# 8. Setup Zsh plugins in .zshrc
# -----------------------------------------------------------------------------
if ! grep -q "zsh-autosuggestions" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Zsh plugins" >> ~/.zshrc
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
fi

# -----------------------------------------------------------------------------
# 9. Final Instructions
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo "✅ Bootstrap complete!"
echo "============================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Run: p10k configure"
echo "  3. Run: gh auth login"
echo "  4. Generate SSH key: ssh-keygen -t ed25519 -C \"your@email.com\""
echo ""
echo "Installed tools:"
echo "  • Homebrew, Git, GitHub CLI"
echo "  • Node.js, Go"
echo "  • kubectl, helm, k9s"
echo "  • fzf, ripgrep"
echo "  • iTerm2, Docker, VS Code"
echo "  • Oh My Zsh + Powerlevel10k"
echo ""