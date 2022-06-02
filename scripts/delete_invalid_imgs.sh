#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

_SNAME=$(basename "$0")
mkdir -p logs/

# Allow deletion of files in dirs
chmod +w Train/* Validation/*

while read file
do
	rm -vf "${file}"
done < invalid_train.out \
	1>logs/${_SNAME}_train.out_$$ 2>logs/${_SNAME}_train.err_$$

while read file
do
	rm -vf "${file}"
done < invalid_validation.out \
	1>logs/${_SNAME}_validation.out_$$ 2>logs/${_SNAME}_validation.err_$$

./scripts/stats.sh Train/*/ Validation/*/

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
