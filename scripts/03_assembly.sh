#!/bin/bash

# Hi-C phased diploid assembly using hifiasm
#
# Key distinction from HiFi-only assembly (Candida):
#   --primary         → pseudo-haplotypes, phase limited to read length (~15 kb)
#   --h1 / --h2       → true haplotype-resolved assembly using Hi-C chromatin contacts
#
# Hi-C provides megabase-scale phasing by linking heterozygous sites
# that are physically co-located within the same nucleus.

set -euo pipefail

mkdir -p ../results/assembly

echo "Running hifiasm with Hi-C phasing..."
hifiasm -o ../results/assembly/yeast \
    -t 8 \
    --h1 ../data/SRR7126301_1.fastq.gz \
    --h2 ../data/SRR7126301_2.fastq.gz \
    ../data/HiFi_synthetic_50x_01.fasta \
    ../data/HiFi_synthetic_50x_02.fasta \
    ../data/HiFi_synthetic_50x_03.fasta

if [ $? -ne 0 ]; then
    echo "Error: hifiasm assembly failed"
    exit 1
fi

echo "Assembly complete. Output files:"
ls -lh ../results/assembly/yeast.hic.*.gfa

# Convert both haplotype GFAs to FASTA
# hifiasm Hi-C mode produces:
#   yeast.hic.hap1.p_ctg.gfa  - haplotype 1 primary contigs
#   yeast.hic.hap2.p_ctg.gfa  - haplotype 2 primary contigs
#   yeast.hic.p_ctg.gfa       - collapsed primary contigs

echo "Converting GFA to FASTA..."

awk '/^S/{print ">"$2; print $3}' \
    ../results/assembly/yeast.hic.hap1.p_ctg.gfa \
    > ../results/assembly/hap1.fasta

awk '/^S/{print ">"$2; print $3}' \
    ../results/assembly/yeast.hic.hap2.p_ctg.gfa \
    > ../results/assembly/hap2.fasta

echo "Haplotype FASTA files:"
seqkit stats ../results/assembly/hap1.fasta ../results/assembly/hap2.fasta
