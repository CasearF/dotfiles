# =========================
# ZSH CONFIG (production)
# =========================

# ---- p10k instant prompt(必须在文件最顶部)----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- ZiM 初始化 ----
ZIM_HOME=${ZDOTDIR:-$HOME}/.zim
source ${ZIM_HOME}/init.zsh

# ---- 基础环境变量 ----
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim

# ---- 历史记录优化 ----
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# ---- 补全体验增强 ----
setopt AUTO_MENU
setopt COMPLETE_IN_WORD

# ---- 目录跳转增强 ----
setopt AUTO_CD

# =========================
# p10k theme
# =========================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =========================
# Aliases (server ops)
# =========================

# ---- eza (带图标的 ls,需 0xProto Nerd Font) ----
alias ls='eza --icons --group-directories-first'
alias ll='eza -alF --icons --group-directories-first --git --header --time-style=relative'
alias la='eza -A --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias lt3='eza --tree --icons --level=3'

# ---- bat (带高亮的 cat,Debian/Ubuntu 上命令名为 batcat) ----
alias cat='batcat --paging=never'
alias bat='batcat'

# 目录跳转
alias ..='cd ..'
alias ...='cd ../..'

# 危险操作加确认
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# grep 上色
alias grep='grep --color=auto'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Docker
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dlog='docker logs -f'
alias dex='docker exec -it'

# Systemd
alias sctl='systemctl'
alias sstart='systemctl start'
alias sstop='systemctl stop'
alias sstat='systemctl status'
alias srestart='systemctl restart'

# Network
alias ports='ss -tulnp'
alias myip='curl -s --max-time 5 ifconfig.me'

# Process
alias psg='ps aux | grep'

# =========================
# performance tweaks
# =========================

export KEYTIMEOUT=1

# =========================
# custom functions
# =========================

# mkdir + cd
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# extract — 通用解压
extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2)  tar xjf "$1" ;;
        *.tar.gz)   tar xzf "$1" ;;
        *.tar.xz)   tar xJf "$1" ;;
        *.tar)      tar xf "$1"  ;;
        *.bz2)      bunzip2 "$1" ;;
        *.gz)       gunzip "$1"  ;;
        *.zip)      unzip "$1"   ;;
        *.7z)       7z x "$1"    ;;
        *.rar)      unrar x "$1" ;;
        *) echo "Unknown format: $1" ;;
    esac
}

# =========================
# tools init (必须在文件末尾)
# =========================

# ---- zoxide (智能目录跳转,用 z 代替 cd) ----
eval "$(zoxide init zsh)"

# ---- fzf (模糊查找,Ctrl+R 历史 / Ctrl+T 文件) ----
source <(fzf --zsh)