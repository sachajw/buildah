#!/bin/bash

set -e

REPO_ROOT=`realpath $(dirname $0)/../../`
TOOL_DIR="$REPO_ROOT/tests/tools/build"

export PATH="$TOOL_DIR:$PATH"
if [[ -z "$(type -P git-validation)" ]]; then
	echo git-validation is not in PATH "$PATH".
	exit 1
fi

if [[ "$TRAVIS" != 'true' ]]; then
	#GITVALIDATE_EPOCH=":/git-validation epoch"
	# Set to the branch's origin point
	GITVALIDATE_EPOCH="3b1d6ebe12445dfe84cb5932634440a20b10fc03"
fi

OUTPUT_OPTIONS="-q"
if [[ "$CI" == 'true' ]]; then
    OUTPUT_OPTIONS="-v"
fi

set -x
exec git-validation \
    $OUTPUT_OPTIONS \
    -run DCO,short-subject \
    ${GITVALIDATE_EPOCH:+-range "${GITVALIDATE_EPOCH}..${GITVALIDATE_TIP:-@}"} \
    ${GITVALIDATE_FLAGS}
