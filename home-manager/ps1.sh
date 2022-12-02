#!/usr/bin/env bash

# Shell prompt based on the Solarized Dark theme.

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;
		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

battery_status()
{
	# this file is in unix systems. You may need to change for your laptop
	# check that dir for BAT0 also.
	BATTERY=/sys/class/power_supply/BAT1

	if [ -d "$BATTERY" ]
	then
		# sometimes these files are energy_foo
		REM_CAP=`cat $BATTERY/charge_now`
		FULL_CAP=`cat $BATTERY/charge_full`
		BATSTATE=`cat $BATTERY/status`

		CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

		NON='\033[00m'
		BLD='\033[01m'
		RED='\033[01;31m'
		GRN='\033[01;32m'
		YEL='\033[01;33m'

		COLOUR="$RED"

		case "${BATSTATE}" in
			'Charged')
			BATSTT="$BLD=$NON"
			;;
			'Charging')
			BATSTT="$BLD+$NON"
			;;
			'Discharging')
			BATSTT="$BLD-$NON"
			;;
		esac

		# prevent a charge of more than 100% displaying
		if [ "$CHARGE" -gt "99" ]
		then
			CHARGE=100
		fi

		if [ "$CHARGE" -gt "15" ]
		then
			COLOUR="$YEL"
		fi

		if [ "$CHARGE" -gt "30" ]
		then
			COLOUR="$GRN"
		fi

		echo -e "${COLOUR}${CHARGE}%${NON}${BATSTT}"
	fi;
}

# Battery status
bat_status() {
	if [[ "$(battery_status)" == "" ]]; then
		echo -e ""
	else
		echo -e "($(battery_status)) "
	fi;
}

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"; # working directory base name
PS1+="\[${bold}\]\n"; # newline
PS1+="\$(bat_status)"
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w"; # working directory full path
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;

