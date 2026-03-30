# Tsetse AMP Pipeline

This pipeline performs in silico identification of antimicrobial peptides from Glossina morsitans morsitans transcriptome data.

## Workflow
1. RNA-seq data download (SRA)
2. Quality control (fastp)
3. Transcriptome assembly (Trinity)
4. Expression quantification (Salmon)
5. Sequence conversion (FASTQ to FASTA)
6. AMP identification using BLASTx

## Tools Used
Trinity, Salmon, fastp, BLAST, SRA Toolkit

## Usage
Run the pipeline using:
bash tsetse_pipeline.sh
