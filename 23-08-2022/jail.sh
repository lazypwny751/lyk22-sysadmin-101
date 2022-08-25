#!/bin/bash

export status="true" JAILDIR="" COUNT="1" SHELL="" OPTARGS=()

for check in "mkdir" "cp" "which" ; do
	if ! command -v "${check}" &> /dev/null ; then
		echo "${0##*/}: ${check} not found."
		export status="false"
	fi
done

if [[ "${status}" = "false" ]] ; then
	exit 1
fi

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

	if [[ -n "${SHELL}" ]] ; then
		if [[ -f "${SHELL}" ]] ; then
			if [[ -f "" ]] ; then
				:
			fi
		else
			echo ""
			exit 1
		fi
	fi
else
	echo "${0##*/} need's the jail parameter."
	exit 1
fi
