#!/bin/bash
set -euo pipefail

# Use system curl explicitly
CURL="/usr/bin/curl"

# Output directory
OUTDIR="./../db/pubmlst/klebsiella"
mkdir -p "$OUTDIR"

# Base URL
BASE_URL="https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef"

# Declare associative array of files and endpoints
declare -A FILES=(
  ["klebsiella.txt"]="$BASE_URL/schemes/1/profiles_csv"
  ["infB.tfa"]="$BASE_URL/loci/infB/alleles_fasta"
  ["pgi.tfa"]="$BASE_URL/loci/pgi/alleles_fasta"
  ["mdh.tfa"]="$BASE_URL/loci/mdh/alleles_fasta"
  ["rpoB.tfa"]="$BASE_URL/loci/rpoB/alleles_fasta"
  ["phoE.tfa"]="$BASE_URL/loci/phoE/alleles_fasta"
  ["tonB.tfa"]="$BASE_URL/loci/tonB/alleles_fasta"
  ["gapA.tfa"]="$BASE_URL/loci/gapA/alleles_fasta"
)

# Download each file
for FILENAME in "${!FILES[@]}"; do
  URL="${FILES[$FILENAME]}"
  echo "Downloading $FILENAME..."
  "$CURL" -fsSL -o "$OUTDIR/$FILENAME" "$URL"
done

echo "All data downloaded successfully to $OUTDIR"
