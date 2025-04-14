# ~/.zshrc
# vim:set ft=zsh: # Set filetype for Vim (keep this at top or bottom)

# --- Basic Configuration ---
# Set default locale
export LANG=ja_JP.UTF-8

# Enable colors
autoload -Uz colors && colors

# --- Environment Variables ---
# Set XDG Base Directory Specification (optional, but good practice)
export XDG_CONFIG_HOME="$HOME/.config"

# Set PATH (consolidated)
# Start with the system default PATH
# Add standard user binary locations
PATH="/usr/local/bin:$PATH"
# Add standard $HOME local user binary locations
PATH="$HOME/.local/bin:$PATH"
# Add Node.js (via nodebrew)
PATH="$HOME/.nodebrew/current/bin:$PATH"
# Add Python (via pyenv) - Note: pyenv init below also modifies PATH
export PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
# Add Go path
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH" # Assuming go binaries are in $GOPATH/bin
# Add Rust (via cargo) - Source the cargo env script
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env" # PATH is set within this script
# Add Kerberos (macOS specific example, adjust if needed)
[[ -d "/usr/local/opt/krb5/bin" ]] && PATH="/usr/local/opt/krb5/bin:$PATH"
[[ -d "/usr/local/opt/krb5/sbin" ]] && PATH="/usr/local/opt/krb5/sbin:$PATH"
# Add Android SDK Platform Tools (adjust path if necessary)
[[ -d "$HOME/Library/Android/sdk/platform-tools" ]] && PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
# Add OpenSSL (macOS specific example, adjust if needed)
[[ -d "/usr/local/opt/openssl@1.1/bin" ]] && PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# Add Konryu (custom tool example)
[[ -d "$HOME/.konryu/bin" ]] && PATH="$PATH:$HOME/.konryu/bin"
# Add git-fuzzy
[[ -d "$HOME/.zsh/git-fuzzy/bin" ]] && PATH="$PATH:$HOME/.zsh/git-fuzzy/bin"
# Export the final PATH
export PATH

# Set GPG TTY
export GPG_TTY=$(tty)

# Set JAVA_HOME
export JAVA_HOME=$HOME/Applications/"Android Studio.app"/Contents/jbr/Contents/Home

# Set Linker Flags for OpenSSL (macOS specific example, adjust if needed)
[[ -d "/usr/local/opt/openssl@1.1/lib" ]] && export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"


# --- History Configuration ---
HISTFILE=~/.zsh_history       # Where to store history
HISTSIZE=1000000              # Max history lines in memory
SAVEHIST=1000000              # Max history lines to save to file
setopt SHARE_HISTORY          # Share history between simultaneous shells
setopt HIST_IGNORE_ALL_DUPS   # If a new command is a duplicate, remove the older entry
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before saving history


# --- Prompt Configuration ---
# VCS (Version Control System) Integration using vcs_info
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'       # Format for non-action states (e.g., clean repo)
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f' # Format for action states (e.g., merging, rebasing)

# Function to update VCS info in the right prompt (RPROMPT)
_update_vcs_info_msg() {
    # Run vcs_info in English to avoid potential locale issues with parsing
    LANG=en_US.UTF-8 vcs_info
    # Set the right prompt to the VCS information
    RPROMPT="${vcs_info_msg_0_}"
}
# Add the function to the precmd hook (runs before each prompt)
add-zsh-hook precmd _update_vcs_info_msg

# Set the main prompt (two lines)
# Line 1: [Exit Status] username > current_directory
# Line 2: Prompt symbol (# for root, % otherwise)
PROMPT="[%?] %{${fg[cyan]}%}%n >%{${reset_color}%} %~
%# "


# --- Shell Options (setopt/unsetopt) ---
setopt PRINT_EIGHT_BIT        # Display 8-bit characters correctly (e.g., Japanese filenames)
setopt NO_BEEP                # Disable the audible terminal bell
setopt NO_FLOW_CONTROL        # Disable Ctrl+S/Ctrl+Q flow control
setopt IGNORE_EOF             # Prevent Ctrl+D from exiting the shell; use 'exit' or 'logout'
setopt INTERACTIVE_COMMENTS   # Allow comments even in interactive shells (starting with #)
setopt AUTO_CD                # Automatically cd into a directory if a command is just its name
setopt AUTO_PUSHD             # Automatically push directories onto the stack when using cd
setopt PUSHD_IGNORE_DUPS      # Don't push duplicate directories onto the stack
setopt EXTENDED_GLOB          # Enable extended globbing features


# --- Completion System ---
autoload -Uz compinit
compinit # Initialize the completion system

# Case-insensitive completion matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Ignore parent directories and current directory when completing after ../
zstyle ':completion:*' ignore-parents parent pwd ..

# Configure sudo completion to search standard command paths
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                                          /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Configure process completion for `ps` command
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


# --- Editing Behavior (ZLE - Zsh Line Editor) ---
# Configure word boundaries for editing commands (e.g., Ctrl+W)
autoload -Uz select-word-style
select-word-style default
# Treat these characters as word separators
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


# --- Keybindings ---
# Enable incremental history search with wildcard support using Ctrl+R
bindkey '^R' history-incremental-pattern-search-backward
# Bind Alt+C (© symbol on some keyboards) to ghq-fzf function (defined later)
# Note: Ensure your terminal sends the correct sequence for Alt+C or change the key.
# If © doesn't work, try '^[c' for Alt+C or choose another binding.
# zle -N ghq-fzf (defined in Functions section)
# bindkey '©' ghq-fzf # Or bindkey '^[c' ghq-fzf


# --- Aliases ---
# General aliases
alias l='ls -a'
alias la='ls -a'
alias ll='ls -l'
alias vim='nvim' # Use neovim instead of vim
alias emacs='nvim' # Redirect emacs to neovim as well (if desired)

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Utility aliases
alias mkdir='mkdir -p'
alias sudo='sudo ' # Keep space after sudo to allow alias expansion
alias g='git'      # Git shortcut
alias cat='bat'    # Use bat instead of cat if available

# Global aliases (apply anywhere in the command line)
alias -g L='| less'
alias -g G='| grep'

# Clipboard alias (conditionally defined)
if command -v pbcopy >/dev/null 2>&1 ; then # macOS
    alias -g C='| pbcopy'
elif command -v xsel >/dev/null 2>&1 ; then # Linux with xsel
    alias -g C='| xsel --input --clipboard'
elif command -v putclip >/dev/null 2>&1 ; then # Cygwin
    alias -g C='| putclip'
# Add other clipboard commands if needed (e.g., wl-copy for Wayland)
fi


# --- OS Specific Settings ---
case ${OSTYPE} in
    darwin*) # macOS
        export CLICOLOR=1
        alias ls='ls -G -F' # Enable color and type indicators for ls
        ;;
    linux*) # Linux
        alias ls='ls -F --color=auto' # Enable color and type indicators for ls
        ;;
    *) # Other OS (FreeBSD, etc.)
        # Add specific settings if needed
        ;;
esac


# --- Plugin & Tool Initialization ---

# Zsh Syntax Highlighting
# Check if the script exists before sourcing
ZSH_SYNTAX_HIGHLIGHTING_DIR="$HOME/.zsh/zsh-syntax-highlighting"
if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh"
fi

# NVM (Node Version Manager)
# Check if the script exists before sourcing
if [[ -s "$HOME/.nvm/nvm.sh" ]] ; then
    export NVM_DIR="$HOME/.nvm" # Set NVM_DIR explicitly if needed
    source "$NVM_DIR/nvm.sh" ;
fi

# rbenv (Ruby Version Manager)
# Check if rbenv is installed before initializing
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

# pyenv (Python Version Manager)
# Check if pyenv is installed before initializing
# Note: PYENV_ROOT and PATH addition are handled in Environment Variables section
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)" # Ensure PATH is correctly setup
    eval "$(pyenv init - zsh)"  # Load pyenv shims and completions
fi

# fzf (Command-line fuzzy finder)
# Check if fzf binary is available and source its keybindings/completion
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# fzf-git.sh
# Check if the script exsts before sourcing
FZF_GIT_DIR="$HOME/.zsh/fzf-git.sh"
if [[ -f "$FZF_GIT_DIR/fzf-git.sh" ]]; then
    source "$FZF_GIT_DIR/fzf-git.sh"
fi


# --- Custom Functions ---

# fbr - checkout git branch (including remote branches) using fzf
fbr() {
    local branches branch
    # Get all local and remote branches, remove HEAD pointer line
    branches=$(git branch --all | grep -v HEAD) &&
    # Use fzf to select a branch
    branch=$(echo "$branches" |
             fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    # Checkout the selected branch, cleaning up the name (removing remote prefix)
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser using fzf
fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                  (grep -o '[a-f0-9]\{7\}' | head -1 |
                  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                  {}
FZF-EOF"
}

# ghq-fzf - cd into selected ghq repository using fzf
# Requires ghq (https://github.com/x-motemen/ghq) and fzf
if command -v ghq >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
    ghq-fzf() {
        local repo_root src target_dir
        repo_root=$(ghq root)
        src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $repo_root/{}/README.* || ls -p $repo_root/{}") # Preview README or list files
        if [[ -n "$src" ]]; then
            target_dir="$repo_root/$src"
            # Check if target is a directory before trying to cd
            if [[ -d "$target_dir" ]]; then
                BUFFER="cd ${target_dir}" # Use ${target_dir} for safety with spaces/special chars
                zle accept-line
            else
                echo "Selected item '$src' is not a directory." >&2 # Error message
            fi
        fi
        zle -R -c # Redraw prompt/line editor
    }
    # Make the function available to ZLE (Zsh Line Editor)
    zle -N ghq-fzf
    # Bind Alt+C (or © if terminal supports it) to the function
    # Try '^[c' if '©' doesn't work
    bindkey '©' ghq-fzf
    # bindkey '^[c' ghq-fzf # Alternative binding for Alt+C
fi


# --- Final Checks / User Specific ---
# Any other user-specific settings or overrides can go here.


# End of ~/.zshrc
# vim:set ft=zsh: # Optional: Vim modeline at the end
