#!/bin/bash

# Quality assessment of both haplotype assemblies
# QUAST: assembly statistics (N50, contig count, GC%)
# BUSCO: gene completeness using saccharomycetes_odb10 (2137 genes)
#
# Note: Run BUSCO on each haplotype separately.
# Expected duplication ~1-2% per haplotype (NOT ~100%) - see README.

set -euo pipefail

mkdir -p ../results/assessment/quast
mkdir -p ../results/assessment/busco_hap1
mkdir -p ../results/assessment/busco_hap2

# --- QUAST ---
echo "Running QUAST on both haplotypes..."
quast.py \
    ../results/assembly/hap1.fasta \
    ../results/assembly/hap2.fasta \
    --labels "hap1,hap2" \
    -o ../results/assessment/quast

if [ $? -ne 0 ]; then
    echo "Error: QUAST failed"
    exit 1
fi

echo "QUAST report:"
cat ../results/assessment/quast/report.txt

# --- BUSCO: Haplotype 1 ---
echo "Running BUSCO on haplotype 1..."
busco \
    -i ../results/assembly/hap1.fasta \
    -l saccharomycetes_odb10 \
    -o busco_hap1 \
    --out_path ../results/assessment/ \
    -m genome \
    --download_path ~/busco_downloads

if [ $? -ne 0 ]; then
    echo "BUSCO hap1 failed - check TROUBLESHOOTING.md"
    exit 1
fi

# --- BUSCO: Haplotype 2 ---
echo "Running BUSCO on haplotype 2..."
busco \
    -i ../results/assembly/hap2.fasta \
    -l saccharomycetes_odb10 \
    -o busco_hap2 \
    --out_path ../results/assessment/ \
    -m genome \
    --download_path ~/busco_downloads

if [ $? -ne 0 ]; then
    echo "BUSCO hap2 failed - check TROUBLESHOOTING.md"
    exit 1
fi

echo "Assessment complete."
echo "Hap1 BUSCO summary:"
cat ../results/assessment/busco_hap1/short_summary*.txt

echo "Hap2 BUSCO summary:"
cat ../results/assessment/busco_hap2/short_summary*.txt
