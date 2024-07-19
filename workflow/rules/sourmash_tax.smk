rule tax_h:
# taxonomy for multifastgather output
    input:
       csv="../results/sourmash/fastgather/{metag_h}.human.gtdb.csv",
    output:
        csv = "../results/sourmash/fastgather/tax/check/{metag_h}.human.tax",
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        sourmash tax metagenome -g {input.csv} \
        -t {GTDB_TAX} -o ../results/sourmash/fastgather/tax/human/{wildcards.metag_h} \
        && touch {output.csv}
        """
rule tax_p:
# taxonomy for multifastgather output
    input:
       csv="../results/sourmash/fastgather/{metag_p}.pig.gtdb.csv",
    output:
        csv = "../results/sourmash/fastgather/tax/check/{metag_p}.pig.tax",
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        sourmash tax metagenome -g {input.csv} \
        -t {GTDB_TAX} -o ../results/sourmash/fastgather/tax/pig/{wildcards.metag_p} \
        && touch {output.csv}
        """