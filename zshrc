#!/usr/bin/zsh
## @File shells/zsh/zshrc
## @Copy ~/.zshrc

#########################################
##               ~/.zshrc              ##
##   The main ZSH configuration file   ##
##                                     ##
##                GGORG                ##
##     https://gh.ggorg.tk/dotfiles    ##
##           shells/zsh/zshrc          ##
#########################################

## @Requires zsh

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

### LOCAL FUNCTIONS ###

file_not_found_error() {
  echo -e "\e[1;31mERROR\e[0m: \e[4;34m$1\e[0;31m not found\e[0m"
}

source_if_present() {
  if [ -f "$1" ]; then
    source "$1"
  elif [ -f "$2" ]; then
    source "$2"
  else
    file_not_found_error "$1"
  fi
}

transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}

### EXPORTS ###

## @Change your editor here
## @Requires neovim
export EDITOR='nvim'
export VISUAL="$EDITOR"

## Sudo prompt
## @Requires sudo
export SUDO_PROMPT="[sudo]  %p's password: "

### HISTORY SETTINGS ###

## Set the history file to ~/.zsh_history
HISTFILE=~/.zsh_history

## Set the shell history size to 1000
HISTSIZE=1000

## Set the file history size to 10000
SAVEHIST=10000

## Basically ignore duplicates
setopt hist_expire_dups_first
setopt hist_ignore_dups

### SHELL OPTIONS ###

## CD into a directory by just typing its name
setopt autocd

## Notify that a backround command has finished
setopt notify

## @Uncomment to hide EOL sign ('%')
#PROMPT_EOL_MARK=""

## Allow comments in interactive mode
setopt interactivecomments

## Enable filename expansion for property (a=b) arguments (used in dd)
setopt magicequalsubst

### KEYBINDINGS ###

## Use Vim keys
## @Comment to use normal (Emacs) keys
bindkey -v

## Exit ZSH
function exit_zsh() { exit; }
zle -N exit_zsh
bindkey '^D' exit_zsh

## Clear the entire backbuffer
function clear-screen-and-scrollback() {
  echoti civis >"$TTY"
  printf '%b' '\e[H\e[2J' >"$TTY"
  zle .reset-prompt
  zle -R
  printf '%b' '\e[3J' >"$TTY"
  echoti cnorm >"$TTY"
}
zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback

### COMPLETION OPTIONS ###

zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

### COMMON $PATH DIRECTORIES ###

## ~/.bin
if [ -d "$HOME/.bin" ]; then
  export PATH="$HOME/.bin:$PATH"
fi

## ~/.local/bin
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

## yarn global bin
if command -v yarn &> /dev/null; then
  if [ -d "$(yarn global bin)" ]; then
    export PATH="$(yarn global bin):$PATH"
  fi
fi

## ~/Applications (a common AppImage directory)
if [ -d "$HOME/Applications" ]; then
  export PATH="$HOME/Applications:$PATH"
fi

## Android SDK
if [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_SDK_ROOT=$HOME/Android/Sdk
  export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
  export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
fi

### TERMINAL TITLE ###

case ${TERM} in
xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | alacritty | st | konsole*)
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
  ;;
*) ;;

esac

### COLORED COMMANDS ###

## ls
alias ls="ls --color=auto"

## grep
## @Requires grep
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

## diff
## @Requires diffutils
alias diff="diff --color=auto"

## ip
## @Requires iproute2
alias ip="ip --color=auto"

### CONFIG FILES ###

## Aliases
if [ -f "$HOME/.aliasrc" ]; then
  source "$HOME/.aliasrc"
else
  file_not_found_error "$HOME/.aliasrc"
fi

### PLUGINS ###

## ZSH-Autosuggestions
## @Requires zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
source_if_present "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

## ZSH-Syntax-Highlighting
## @Requires zsh-syntax-highlighting
source_if_present "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

## ZSH-You-Should-Use
## @Requires aur:zsh-you-should-use
source_if_present "/usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh"

## ArchLinux Command Not Found
## @Requires pkgfile
source_if_present "/usr/share/doc/pkgfile/command-not-found.zsh"

## BatPipe
## @Requires bat-extras
eval "$(batpipe)"

## Zoxide
## @Requires zoxide
eval "$(zoxide init zsh)"

## FZF
## @Requires fzf
if [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"
else
  source_if_present "/usr/share/fzf/key-bindings.zsh"
  source_if_present "/usr/share/fzf/completion.zsh"
fi

## Starship prompt
## @Requires starship
## @Requires ttf-font-nerd
## @Needs shells/starship-prompt
eval "$(starship init zsh)"

## User config
if [ -f "$HOME/.zshrc.user" ]; then
  source "$HOME/.zshrc.user"
fi
