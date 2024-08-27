# imports 
import os
import pandas as pd

# all genomes
GENOMES, = glob_wildcards('../results/MAGs/genomes/{ident}.fasta')
# Genomes with a crispr array defined by Minced
CRISPR_GENOMES = pd.read_csv("../results/crispr/mag_w_spacer.txt", header=None)[0].tolist()

rule all:
    input:
        expand("../results/crispr/minced/{ident}.txt", ident=GENOMES),
        expand("../results/prokka/check/{ident}.done", ident=CRISPR_GENOMES),

rule prokka:
    input:
        fasta = '../results/MAGs/genomes/{ident}.fasta', 
    output:
        txt='../results/prokka/check/{ident}.done',
    conda: 
        "prokka"
    threads: 6
    shell:
        """
        prokka {input.fasta} \
        --outdir ../results/prokka/prokka_res/{wildcards.ident} \
        --prefix {wildcards.ident} --kingdom bacteria, --norrna \
        --notrna --cpus {threads} --addgenes && touch {output.txt}
        """

rule minced:
    input:
        fasta = '../results/MAGs/genomes/{ident}.fasta', 
    output:
        txt='../results/crispr/minced/{ident}.txt',
    conda: 
        "minced"
    threads: 1
    shell:
        """
        minced -spacers {input.fasta} {output.txt}
        """
