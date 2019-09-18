#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

export PATH="${PATH}:bin"

! python3 -m pip install --no-cache-dir -U crcmod

mkdir -p Train/ Validation/

gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://gcc-data/Train/GCC-training.tsv" Train/
git-annex add Train/
gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://gcc-data/Validation/GCC-1.1.0-Validation.tsv" Validation/
git-annex add Validation/
gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
	cp -R "gs://conceptual-captions-v1-1-labels/Image_Labels_Subset_Train_GCC-Labels-training.tsv" .
git-annex add Image_Labels_Subset_Train_GCC-Labels-training.tsv

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
