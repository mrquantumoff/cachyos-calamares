# qdrnt zsh configuration: oh-my-zsh with the duellj theme.
# Installed to /usr/local/share/qdrnt/qdrnt.zsh and sourced from ~/.zshrc.
# Put personal settings in ~/.zshrc after the `source` line.

# --- oh-my-zsh (system-wide install from oh-my-zsh-git) ---------------------
export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="duellj"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
[[ -d $ZSH_CACHE_DIR/completions ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
zstyle ':omz:update' mode disabled   # updated by pacman, not by omz
DISABLE_MAGIC_FUNCTIONS=true         # don't mangle pasted URLs
COMPLETION_WAITING_DOTS=true
HIST_STAMPS="yyyy-mm-dd"
export FZF_BASE=/usr/share/fzf

# Built-in oh-my-zsh plugins. ~/.zshrc may set `plugins=(...)` before sourcing
# this file (the installer writes the list picked on its "Zsh plugins" page).
(( ${+plugins} )) || plugins=(
    git                 # git aliases + prompt info
    sudo                # press Esc twice to prefix the last command with sudo
    extract             # `x <archive>` extracts anything
    fzf                 # Ctrl-R history search, Ctrl-T file picker, Alt-C cd
    colored-man-pages
    copypath            # copy $PWD (or a path) to the clipboard
    copyfile            # copy a file's contents to the clipboard
    copybuffer          # Ctrl-O copies the current command line
    dirhistory          # Alt-Left/Right/Up to move through directories
    archlinux           # pacman/paru aliases (pacupg, pacin, ...)
    systemd             # sc-status, sc-restart, ...
    docker
    docker-compose
    aliases             # `als` lists all aliases
    history-substring-search   # Up/Down search history for the typed prefix
    command-not-found   # suggests the package for an unknown command (pkgfile)
)

# zsh-syntax-highlighting (package pulled in by cachyos-zsh-config). It must be
# loaded before the history-substring-search plugin; with zsh >= 5.9 it no
# longer needs to be the very last thing sourced.
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source "$ZSH/oh-my-zsh.sh"

# Some terminals send ^[[A/^[[B for Up/Down even in keypad mode; bind both.
if (( ${plugins[(Ie)history-substring-search]} )); then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# --- History ------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY

# --- Completion -----------------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'   # case-insensitive, fuzzy-ish
zstyle ':completion:*' menu select

# --- Aliases --------------------------------------------------------------------
alias update="sudo pacman -Syu"
alias rmpkg="sudo pacman -Rsn"
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias jctl="journalctl -p 3 -xb"

# --- zsh-autosuggestions (package pulled in by cachyos-zsh-config) ------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
