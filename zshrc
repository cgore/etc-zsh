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
if [[ -z "$skip_global_compinit" ]] {
  autoload -U compinit
  compinit
}

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep

alias suxl='sux -l'

alias ls='ls --color'
alias l='ls -lh'

alias grep='grep --color'
alias fgrep='grep -r --with-filename --line-number --initial-tab'
alias ccgrep='fgrep --include="*.[ch]" --include="*.cpp" --include="*.c++"'
alias rbgrep='fgrep --include="*.rb"'
alias pygrep='fgrep --include="*.py"'
alias pwgrep='ps auxww|head -1; ps auxww|grep'

alias drc='fakeroot debian/rules clean'
alias drb='fakeroot debian/rules binary'

alias gf='git fetch'
alias gfa='git fetch --all'
alias gp='git pull'
alias gP='git push'
alias gC='git commit -m'
alias gpr='git pull --rebase'
alias g\?='git status'
alias glog='git log'
alias g-='git diff'
alias g-h='git diff HEAD'
alias g+='git add'
alias git-curbranch='g?|grep "^# On branch "|cut -c 13-'
alias gM='git merge --no-ff'
function git-newbranch {
    if (( ${#1} <= 1 )) {
        echo "ERROR: must specify new branch name."
	exit 1
    }
    git fetch
    if ( git branch -r | grep origin/$1 ) {
        echo "ERROR: origin/$1 already exists."
        exit 2
    }
    local old_branch=$(git-curbranch)
    git branch      $1          && \
    git checkout    $1          && \
    git push origin $1          && \
    git checkout    $old_branch && \
    git branch -d   $1          && \
    git checkout -t origin/$1
}
alias g+b='git-newbranch'

alias ta='tig --all'

alias git-authors='git log|grep \^Author:|sort|uniq'
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

typeset PS1="%(#.%F{magenta}.%F{cyan})%B%n@%m %#%b%f "
# typeset RPS1="%(#.%F{magenta}.%F{cyan})%B%~ %(?..%S)[%?]%(?..%s) %t %W%b%f"

if [[ $(hostname) == abaddon ]] { # Camber-specific workstation configuration.
    alias slamr2env='. /etc/profile.d/slamr2.sh'
    export DEBFULLNAME='Christopher Mark Gore'
    export DEBEMAIL='chgore@camber.com'
}

for extension in .c .cpp .c++ .lisp .py .rb .txt .log .conf
    alias -s $extension=gvim
