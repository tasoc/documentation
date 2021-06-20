#!/bin/bash -e
set -e

# Default settings:
OVERWRITE=false
BRANCH="devel"

#
while getopts 'hob:' OPTION; do
	case "$OPTION" in
	h)
		echo "script usage: $(basename $0) [-h] [-e]" >&2
		exit 1
		;;
	o)
		OVERWRITE=true
		;;
	b)
		BRANCH="$OPTARG"
		;;
	?)
		echo "script usage: $(basename $0) [-h] [-e]" >&2
		exit 1
		;;
	esac
done
shift "$(($OPTIND -1))"

#--------------------------------------------------------------------------------------------------
for SUBPACKAGE in "photometry" "dataval" "corrections" "starclass"; do
	echo "**********************************************************"
	if [ "$OVERWRITE" = "true" ]; then
		echo "Deleting old $SUBPACKAGE..."
		rm -rf "../$SUBPACKAGE"
	fi
	if [ ! -e "../$SUBPACKAGE" ]; then
		echo "Setting up $SUBPACKAGE..."
		GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/tasoc/$SUBPACKAGE.git --branch $BRANCH --single-branch ../$SUBPACKAGE
	else
		echo "$SUBPACKAGE already exists"
	fi
done
