#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

_SNAME=$(basename "$0")
mkdir -p logs/

python3 -m pip install -r scripts/requirements_validate_imgs.txt

for d in Train/* ; do find $d -type f | sort -u ; done | python3 scripts/validate_imgs.py - \
	1>invalid_train.out 2>logs/${_SNAME}_train.err_$$
for d in Validation/* ; do find $d -type f | sort -u ; done | python3 scripts/validate_imgs.py - \
	1>invalid_validation.out 2>logs/${_SNAME}_validation.err_$$
