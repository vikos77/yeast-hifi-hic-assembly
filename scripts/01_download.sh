#!/bin/bash

# Download HiFi + Hi-C data for S. cerevisiae S288C
# HiFi reads: Zenodo 6098306 (synthetic 50x diploid dataset)
# Hi-C reads:  SRR7126301 (NCBI SRA, Illumina paired-end)

set -euo pipefail

mkdir -p ../data

# --- HiFi reads (Zenodo 6098306) ---
echo "Downloading HiFi reads from Zenodo..."
ZENODO_HiFi="https://zenodo.org/record/6098306/files"

wget -P ../data/ "${ZENODO_HiFi}/HiFi_synthetic_50x_01.fasta"
wget -P ../data/ "${ZENODO_HiFi}/HiFi_synthetic_50x_02.fasta"
wget -P ../data/ "${ZENODO_HiFi}/HiFi_synthetic_50x_03.fasta"

echo "HiFi files downloaded:"
ls -lh ../data/HiFi_synthetic_50x_*.fasta

# --- Hi-C reads (SRA SRR7126301) ---
echo "Downloading Hi-C reads from SRA..."
fasterq-dump SRR7126301 --split-files --outdir ../data/

# Compress Hi-C reads (hifiasm expects .fastq.gz)
echo "Compressing Hi-C reads..."
gzip ../data/SRR7126301_1.fastq
gzip ../data/SRR7126301_2.fastq

echo "Hi-C files downloaded:"
ls -lh ../data/SRR7126301_*.fastq.gz

echo "All downloads complete."
