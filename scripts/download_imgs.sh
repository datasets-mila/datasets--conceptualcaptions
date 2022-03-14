#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

_SNAME=$(basename "$0")
mkdir -p logs/

function files_url {
	_tsf_file=$1
	_prefix=$2
	local counter=0
	while read l
	do 
		local url=$(echo "$l" | cut -f2)
		local filename=$(echo "$url" | md5sum | cut -d" " -f1)
		echo -ne "${_prefix}$(printf "%06d/%012d-${filename}" $((counter/1000)) ${counter})\0$(echo "$l" | cut -f2)\0"
		local counter=$((counter+1))
	done < "$1"
}

function download_files {
	_tsf_file=$1
	_dest=$2
	_lines_cnt=$(wc -l ${_tsf_file} | cut -d" " -f1)
	for (( c=0 ; c<=$((_lines_cnt/1000)) ; c++ ))
	do
		mkdir -p "${_dest}/$(printf "%06d" $c)"
	done
	# Some files downloads are expected to fail
	set +o errexit
	files_url "${_tsf_file}" "${_dest}/" | xargs -0 -n2 -P64 -- \
		curl --continue-at - --insecure --location --retry 5 --connect-timeout 60 --max-time 1800 --retry-connrefused \
		--remote-time \
		-w "\n====================\n%{url_effective} -> %{filename_effective}:%{size_download}:%{http_code}\n====================\n" \
		-H 'User-Agent: Firefox/98.0' -H 'Accept-Language: *' -H 'Accept: *, */*' -H 'Accept-Encoding: gzip, deflate, br, *' \
		--output
	set -o errexit
}

chmod -R +w Train/ Validation/
download_files "Train/GCC-training.tsv" Train \
	1>logs/${_SNAME}_train.out_$$ 2>logs/${_SNAME}_train.err_$$
download_files "Validation/GCC-1.1.0-Validation.tsv" Validation \
	1>logs/${_SNAME}_validation.out_$$ 2>logs/${_SNAME}_validation.err_$$

./scripts/stats.sh Train/*/ Validation/*/

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
