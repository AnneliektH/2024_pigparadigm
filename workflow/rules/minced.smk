GENOMES, = glob_wildcards('../../results/MAGs/genomes/{ident}.fasta')

rule all:
    input:
        expand("../../results/crispr/minced/{ident}.txt", ident=GENOMES),
        

rule minced:
    input:
        fasta = '../../results/MAGs/genomes/{ident}.fasta', 
    output:
        txt='../../results/crispr/minced/{ident}.txt',
    conda: 
        "minced"
    threads: 1
    shell:
        """
        minced -spacers {input.fasta} {output.txt}
        """
