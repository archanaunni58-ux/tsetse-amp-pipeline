#!/bin/bash

# =========================
# Tsetse AMP Pipeline
# =========================

# Step 1: Download RNA-seq data
fastq-dump --gzip --skip-technical --readids \
--defline-seq '@$sn[_$rn]/$ri' \
--defline-qual '+' \
--outdir ./ SRR5026206


# Step 2: Activate environment
conda activate trinity_env


# Step 3: Quality Control
fastp \
-i SRR5026206.fastq.gz \
-o SRR5026206.clean.fastq.gz \
-q 20 \
-l 50 \
-h fastp.html \
-j fastp.json


# Step 4: Transcriptome Assembly
Trinity \
--seqType fq \
--single SRR5026206.clean.fastq.gz \
--CPU 10 \
--max_memory 50G \
--output trinity_tsetse


# Step 5: Salmon Indexing
salmon index \
-t trinity_tsetse/Trinity.fasta \
-i salmon_index


# Step 6: Quantification
salmon quant \
-i salmon_index \
-l A \
-r SRR5026206.clean.fastq.gz \
-p 10 \
-o salmon_output \
--validateMappings


# Step 7: Convert FASTQ to FASTA
zcat SRR5026206.clean.fastq.gz | \
awk 'NR%4==1 {print ">" substr($0,2)} NR%4==2 {print}' \
> SRR5026206.fasta


# Step 8: Create BLAST database
makeblastdb \
-in insectAMPs_APD2024.fasta \
-dbtype prot \
-out insectAMPs_APD2024


# Step 9: BLASTx search for AMP identification
blastx \
-query SRR5026206.fasta \
-db insectAMPs_APD2024 \
-out SRR5026206_AMP.txt \
-evalue 1e-5 \
-outfmt 6