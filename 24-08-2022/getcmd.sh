#!/bin/bash

#    Get command binaries to jail using LDD (shared object dependencies) - getcmd.sh
#    Copyright (C) 2022  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>

# get command is just detects shared object dependencies (using: ldd) of given commands
# in PATH and copy the founded binaries to jail directory.

# Default variables.
export status="true" COUNT="1" SHELL="" JAILDIR="" OPTARGS=()

# Check requirement commands.
for check in "mkdir" "cp" "which" ; do
	if ! command -v "${check}" &> /dev/null ; then
		echo "${0##*/}: ${check} not found."
		export status="false"
	fi
done

# If the requirement commands are not in PATH then exit.
if [[ "${status}" = "false" ]] ; then
	exit 1
fi

# Argv parsing.
while [[ "${#}" -gt 0 ]] ; do
	case "${1}" in
		--shell|-s)
			shift
			if [[ -n "${1}" ]] ; then
				export SHELL="${1}"
				shift
			fi
		;;
		--jail|-j)
			shift
			if [[ -d "${1}" ]] ; then
				export JAILDIR="${1}"
				shift
			fi
		;;
		*)
			export OPTARGS+=("${1}")
			shift
		;;
	esac
done

# Execute the options from parameters.
if [[ -n "${JAILDIR}" ]] ; then
	export cmd=""
	for i in ${OPTARGS[@]} ; do
		echo "--- BEGIN ${i^^} ---"
		export cmd="$(which "${i}")" SUBCOUNT="0"
		echo -e "[${COUNT}.${SUBCOUNT}]\t${cmd}"
		mkdir -p "${JAILDIR}/${cmd%/*}" && {
			cp "${cmd}" "${JAILDIR}${cmd}"
		}
		for x in $(ldd "${cmd}") ; do
			if [[ "${x}" = *"/"* ]] ; then
				export SUBCOUNT="$((SUBCOUNT + 1))"
				mkdir -p "${JAILDIR}/${x%/*}"
				cp "${x}" "${JAILDIR}${x}"
				echo -e "[${COUNT}.${SUBCOUNT}]\t${x} "
			fi
		done
		echo "---- END ${i^^} ----"
		export COUNT="$((COUNT + 1))"
	done

	# if the SHELL option are definied then run the shell in jail (chroot).
	if [[ -n "${SHELL}" ]] ; then
		if [[ -f "${JAILDIR}${SHELL}" ]] ; then
			if [[ "${UID}" = 0  ]] ; then
				chroot "${JAILDIR}" "${SHELL}"
			elif [[ "${UID}" != 0  ]] && command -v "sudo" &> /dev/null ; then
				sudo chroot "${JAILDIR}" "${SHELL}"
			elif [[ "${UID}" != 0 ]] && command -v "doas" &> /dev/null ; then
				doas chroot "${JAILDIR}" "${SHELL}"
			else
				echo "please run it as root privalages!"
				exit 1
			fi
		else
			echo "there is no shell located as '${SHELL}' in '${JAILDIR##*/}'."
			exit 1
		fi
	fi
else
	# there is no help argument but if the options not met
	# it will show the simple usage text.
	echo -e "${0##*/}'s usage: there is 2 options: ${0##*/} [OPTIONS].. [PARAMS]..;\n\t${0##*/} --jail <dir>\n\t\tFounded binaries are goes this directory so this option will be Current Work Directory and this argument is required.\n\t${0##*/} --shell \${JAILDIR}</usr/bin/shell>\n\t\tThis option is just for test if the binaries are met, not for directly usage."
	exit 1
fi
