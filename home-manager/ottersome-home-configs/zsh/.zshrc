# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/home/ottersome/.oh-my-zsh" # UNCOMMENT: If not using nix



# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="miloshadzic"
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git zsh-autosuggestions)
### BEGIN: PLUGMAN
plugins=(zsh-completions zsh-autosuggestions ssh-agent poetry fzf-tab git)
# source $ZSH/oh-my-zsh.sh # UNCOMMENT: If not using nix

# Plugin Configuration
autoload -U compinit && compinit
### END: PLUGMAN 

# Better History
HIST_STAMPS="%g-%m-%d"
HIST_SIZE=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space


### User configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -lh $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -lh $realpath'
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

zstyle :omz:plugins:ssh-agent identities id_rsa 
zstyle :omz:plugins:ssh-agent lazy yes


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
bindkey -v
# setxkbmap -option caps:escape
alias ff="fzf --height 40% --layout reverse --info inline --border \
        --preview 'file {}' --preview-window down:1:noborder \
            --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"

alias fv="vim \$(fzf --height 40% --layout reverse --info inline --border \
        --preview 'file {}' --preview-window down:1:noborder \
        --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899')"
PATH=$PATH:~/tools/arm-bcm2708/arm-linux-gnueabihf/bin
PATH=$PATH:~/.local/bin
PATH=$PATH:~/.cargo/bin
#eval "$(pyenv init -)"

alias vim="nvim"
alias open="xdg-open"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ottersome/tmp/google-cloud-sdk/path.zsh.inc' ]; then . '/home/ottersome/tmp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ottersome/tmp/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/ottersome/tmp/google-cloud-sdk/completion.zsh.inc'; fi

if [ "$TMUX" = "" ]; then tmux; fi

# ssh agent utility
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#   ssh-agent > ~/.ssh-agent-env
# fi
#
# # Load ssh-agent environment variables
# if [[ -f ~/.ssh-agent-env ]]; then
#   source ~/.ssh-agent-env > /dev/null
# fi


# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey ^l _sgpt_zsh
# Shell-GPT integration ZSH v0.2
alias res="cd ~/Research/Polimi/SampledDetection && poetry shell && nvim"
alias notes="cd ~/Documents/LeVault && nvim"
alias cvim="cd ~/.config/nvim && nvim"
fex() {
  local selected_command=$(history |  fzf | awk '{$1="";$2=""; print substr($0,2)}' )
  LBUFFER="${selected_command}"
  ZLE_REDRAW_LINE=true
  zle reset-prompt
}
sourcezshrc() {
   source ~/.zshrc
   echo "Reloaded .zshrc"
}
zle -N fex
zle -N sourcezshrc
bindkey '^R' sourcezshrc
bindkey '^F' fex
# export OPENAI_API_KEY="$(gpg --decrypt -q ~/.config/openai/secret.key.gpg)"
alias gpt="sgpt --model gpt-4o"
alias wttr="curl wttr.in/hsinchu"
export STOW_DIR="~/dotfiles/"


alias l="eza -lh --group-directories-first"
alias lt="eza -T -L 2 "

export PATH=$PATH:$HOME/go/bin
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#
