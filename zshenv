# /etc/zsh/zshenv: system-wide .zshenv file for zsh(1).
#
# This file is sourced on all invocations of the shell.
# If the -f flag is present or if the NO_RCS option is
# set within this file, all other initialization files
# are skipped.
#
# This file should contain commands to set the command
# search path, plus other important environment variables.
# This file should not contain commands that produce
# output or assume the shell is attached to a tty.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]] {
	export PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"
}
export PATH="${PATH}:${HOME}/bin"
if [[ $(hostname) == abaddon ]] { # Camber-specific configuration.
    if [[ -e /etc/profile.d/slamr2.sh ]] {
        . /etc/profile.d/slamr2.sh
    }
}
