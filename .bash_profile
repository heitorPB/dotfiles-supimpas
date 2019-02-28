# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for filee in ~/.{path,functions,bash_prompt,exports,aliases,extra}; do
	[ -r "$filee" ] && [ -f "$filee" ] && source "$filee";
done;
unset filee;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# checks the window size after each command and, if necessary, updates the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# need package bash-completions installed
# Add tab completion for many Bash commands
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion;

# Enable tab completion for `g` by marking it as an alias for `git`
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git && complete -o default -o nospace -F _git g;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "firefox spotify" killall;
