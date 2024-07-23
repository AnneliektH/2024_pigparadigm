# filter contigs per bacterial species table
rule pick_species:
    output: 
        sig = "../results/pangenome/{species}.gtdb.csv"
    conda: 
        "branchwater"
    params:
        # Use the original species name for the shell command
        species=lambda wildcards: next(species for species in PANG_SPECIES if format_species_name(species) == wildcards.species)
    shell:
        """
        sourmash tax grep -i "{params.species}" \
        -t {GTDB_TAX} -o {output.sig}
        """

#filter contigs per bacterial species table
rule pang_sketch:
    input: 
        picklist = "../results/pangenome/{species}.gtdb.csv"
    output: 
        sig = "../results/pangenome/{species}.zip",
        pang = "../results/pangenome/{species}.pang.sig.gz",
        rankt = "../results/pangenome/rankt/{species}.rankt.csv"
    conda: 
        "branchwater"
    shell:
        """
        sourmash sig cat --picklist {input.picklist}:ident:ident \
        {GTDB} -o {output.sig} && \
        sourmash scripts pangenome_merge \
        {output.sig} -o {output.pang} -k {KSIZE} && \
        sourmash scripts pangenome_ranktable {output.pang} -o {output.rankt} -k {KSIZE}
        """

# Now do the pangenome classify for 10 metagenomes
rule classify:
    input:
       rankt = "../results/pangenome/{species}.rankt.csv",
       metag = lambda wildcards: get_input_file_path(wildcards.metag) 
    output:
        txt="../results/pangenome/{folder_species}/{species}x{metag}.txt"
    params:
        # Use the function to determine the output directory
        folder_species=lambda wildcards: get_output_dir(wildcards.metag)
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        sourmash scripts pangenome_classify \
        {input.metag} {input.rankt} -k {KSIZE} > {output.txt}
        """



rule calc_hash_presence_h:
    input:
       rankt = "../results/pangenome/{species}.rankt.csv",
       sig = calc_hash_input_human
    output:
        dmp = "../results/pangenome/dmp_human/{species}.x.human.dump",
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        python scripts/calc-hash-presence.py \
        {input.rankt} {input.sig} --scaled=1000 -k {KSIZE} -o {output.dmp}
        """
rule calc_hash_presence_p:
    input:
       rankt = "../results/pangenome/{species}.rankt.csv",
       sig = calc_hash_input_pig
    output:
        dmp = "../results/pangenome/dmp_pig/{species}.x.pig.dump",
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        python scripts/calc-hash-presence.py \
        {input.rankt} {input.sig} --scaled=1000 -k {KSIZE} -o {output.dmp}
        """
## Compare dmp files
rule compare_dmp:
    input:
       dmp1 = "../results/pangenome/dmp_human/{species}.x.human.dump",
       dmp2 = '../results/pangenome/dmp_pig/{species}.x.pig.dump'
    output:
        cmp = "../results/pangenome/dmp/{species}.cmp.tsv",
    conda: 
        "branchwater"
    threads: 1
    shell:
        """ 
        python scripts/parse-dump.py \
        --dump-files-1 {input.dmp1} \
        --dump-files-2 {input.dmp2} > {output.cmp}
        """
