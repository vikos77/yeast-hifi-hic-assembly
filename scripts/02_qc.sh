#!/bin/bash

# Quality control for HiFi and Hi-C reads
# HiFi: seqkit stats + NanoPlot (long-read QC)
# Hi-C: FastQC (short-read Illumina QC)

set -euo pipefail

mkdir -p ../results/qc/hifi_nanoplot
mkdir -p ../results/qc/hic_fastqc

# --- HiFi QC ---
echo "Running seqkit stats on HiFi reads..."
seqkit stats \
    ../data/HiFi_synthetic_50x_01.fasta \
    ../data/HiFi_synthetic_50x_02.fasta \
    ../data/HiFi_synthetic_50x_03.fasta \
    > ../results/qc/hifi_stats.txt

echo "HiFi read statistics:"
cat ../results/qc/hifi_stats.txt

# Confirm HiFi data: mean read length should be > 10 kb
echo ""
echo "Running NanoPlot on HiFi reads (combined)..."
cat ../data/HiFi_synthetic_50x_0*.fasta > /tmp/hifi_combined.fasta
NanoPlot --fasta /tmp/hifi_combined.fasta \
    --outdir ../results/qc/hifi_nanoplot \
    --prefix yeast_hifi_
rm /tmp/hifi_combined.fasta

# --- Hi-C QC ---
echo "Running FastQC on Hi-C reads..."
fastqc \
    ../data/SRR7126301_1.fastq.gz \
    ../data/SRR7126301_2.fastq.gz \
    --outdir ../results/qc/hic_fastqc \
    --threads 4

echo "QC complete. Results in results/qc/"
