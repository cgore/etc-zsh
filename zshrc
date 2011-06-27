# /etc/zsh/zshrc: system-wide .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

READNULLCMD=${PAGER:-/usr/bin/pager}

if [[ "$TERM" != emacs ]] {
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line
    [[ -z "$terminfo[kich1]" ]] || bindkey -M emacs "$terminfo[kich1]" overwrite-mode
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
    [[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd "$terminfo[kich1]" overwrite-mode

    [[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
    [[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
    [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
    [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

    # ncurses fogyatekos
    [[ "$terminfo[kcuu1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
    [[ "$terminfo[kcud1]" == "O"* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
    [[ "$terminfo[kcuf1]" == "O"* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
    [[ "$terminfo[kcub1]" == "O"* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
    [[ "$terminfo[khome]" == "O"* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]" == "O"* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
    [[ "$terminfo[khome]" == "O"* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]" == "O"* ]] && bindkey -M emacs "${terminfo[kend]/O/[}" end-of-line
}

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
			     /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

unalias run-help
autoload run-help

# If you don't want compinit called here, place the line
# skip_global_compinit=1
# in your $ZDOTDIR/.zshenv or $ZDOTDIR/.zprofice
if [[ -z "$skip_global_compinit" ]]; then
  autoload -U compinit
  compinit
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep
bindkey -v

alias suxl='sux -l'
alias ls='ls --color'
alias l='ls -lh'
alias ccgrep='grep -r --include="*.[ch]"'
alias rbgrep='grep -r --include="*.rb"'
alias pygrep='grep -r --include="*.py"'
alias pwgrep='ps auxww|grep'

alias gf='git fetch'
alias gfetch='git fetch'
alias gitf='git fetch'
alias git\?='git status'
alias g\?='git status'
alias gst='git status'
alias gitst='git status'
alias gitstat='git status'
alias glog='git log'
alias gdf='git diff'
alias g-='git diff'
alias git+='git add'
alias g+='git add'

function git-newbranch {
    if (( 0 < ${#1} )) then
        git branch      $1 && \
	git checkout    $1 && \
	git push origin $1
    else
        echo "ERROR: must specify new branch name."
	exit 1
    fi
}
alias gnb='git-newbranch'
alias g+b='git-newbranch'

alias git-authors='git log|grep Author|sort|uniq'
alias git-all-origin-branches='git show-ref|sort|cut -d " " -f 2|grep refs/remotes/origin|cut -d "/" -f 4'

function git-addremove {
    git add .
    git ls-files --deleted | xargs git rm
}
alias git-addrm='git-addremove'

function git-all-controlled-files {
    git ls-tree -r HEAD|sed -re 's/^.{53}//'
}

function git-blame-loc {
    git ls-tree -r HEAD|sed -re 's/^.{53}//' |
    while read filename; do file "$filename"; done |
    grep -E ': .*text'|sed -r -e 's/: .*//' |
    while read filename; do git blame "$filename"; done |
    sed -r -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//' |
    sort |
    uniq -c |
    sort -n
}

typeset PS1="%(#.%F{red}.%F{cyan})%B%n@%m %#%b%f "
typeset RPS1="%(#.%F{red}.%F{cyan})%B%~ %(?..%S)[%?]%(?..%s) %t %W%b%f"

if [[ $(hostname) == abaddon ]] { # Camber-specific configuration.
    alias slamr2env='. /etc/profile.d/slamr2.sh'
    export DEBFULLNAME='Christopher Mark Gore'
    export DEBEMAIL='chgore@camber.com'
}
