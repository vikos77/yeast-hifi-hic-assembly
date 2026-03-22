# Troubleshooting

## hifiasm produces only one haplotype output

**Symptom:** Only `yeast.hic.p_ctg.gfa` present, no `yeast.hic.hap1.p_ctg.gfa` or `yeast.hic.hap2.p_ctg.gfa`.

**Cause:** Hi-C reads were not provided, or the `--h1`/`--h2` flags were omitted. Without Hi-C, hifiasm falls back to `--primary` mode.

**Fix:** Confirm both Hi-C files exist and re-run with the correct flags:
```bash
ls -lh ../data/SRR7126301_1.fastq.gz ../data/SRR7126301_2.fastq.gz
```

---

## Hi-C reads must be gzipped

**Symptom:** hifiasm errors on Hi-C input files.

**Cause:** hifiasm's `--h1/--h2` mode expects `.fastq.gz` format.

**Fix:** Compress after fasterq-dump:
```bash
gzip ../data/SRR7126301_1.fastq
gzip ../data/SRR7126301_2.fastq
```

---

## BUSCO import errors (numpy conflict)

**Symptom:**
```
ImportError: cannot import name 'bool' from 'numpy'
```

**Cause:** BUSCO 5.x requires numpy 1.x. numpy 2.0 removed deprecated aliases.

**Fix:** The `longread_assembly_hic.yaml` pins `numpy<2`. If you installed manually:
```bash
conda install -c conda-forge "numpy<2"
```

---

## BUSCO `--out_path` directory conflict

**Symptom:** BUSCO errors saying the output directory already exists.

**Cause:** BUSCO will not overwrite an existing output directory.

**Fix:** Delete the existing directory before re-running:
```bash
rm -rf ../results/assessment/busco_hap1
```

---

## Zenodo download fails

**Symptom:** `wget` returns 404 or connection refused.

**Fix:** Visit [https://zenodo.org/record/6098306](https://zenodo.org/record/6098306) to confirm the URLs are current — Zenodo records occasionally move. Download manually and place files in `data/`.

---

## hifiasm runs out of memory

**Symptom:** Assembly killed with OOM error.

**Note:** This dataset (~50× coverage, 12 Mb genome) should assemble comfortably in 16 GB. If you're running other processes simultaneously, try:
```bash
# Reduce threads (also reduces peak memory)
hifiasm -o yeast -t 4 --h1 ... --h2 ...
```

---

## NanoPlot fails on FASTA input

**Symptom:** NanoPlot errors when given `.fasta` files.

**Cause:** NanoPlot's `--fasta` flag expects standard FASTA but can be picky about headers.

**Fix:** Use `seqkit seq` to normalise the input first:
```bash
cat ../data/HiFi_synthetic_50x_0*.fasta | seqkit seq > /tmp/hifi_combined.fasta
NanoPlot --fasta /tmp/hifi_combined.fasta --outdir ../results/qc/hifi_nanoplot/
```

---

## FastQC not found

**Symptom:** `command not found: fastqc`

**Fix:**
```bash
conda activate longread-assembly-hic
conda install -c bioconda fastqc=0.12.1
```
