rule fastgather_MAGs: 
# works
    input:
       sig = lambda wildcards: get_input_file_path(wildcards.metag),
       db = '../results/sourmash/sketches/MAGs.drep999.zip'
    output:
        csv = "../results/sourmash/fastgather/{metag}.{outputname}.999.csv",
    conda: 
        "branchwater"
    threads: 10
    shell:
        """ 
        sourmash scripts fastgather \
        {input.sig} {input.db} \
        -k {KSIZE} --scaled 1000 \
        -c {threads} -o {output.csv}
        """
        
rule fastgather_gtdb:
# works
    input:
       sig = lambda wildcards: get_input_file_path(wildcards.metag),
    output:
        csv = "../results/sourmash/fastgather/{metag}.{outputname}.gtdb.csv",
    params:
        # Use the function to determine the output directory
        outputname=lambda wildcards: get_output_name(wildcards.metag)
    conda: 
        "branchwater"
    threads: 10
    shell:
        """ 
        sourmash scripts fastgather \
        {input.sig} {GTDB} \
        -k {KSIZE} --scaled 1000 \
        -c {threads} -o {output.csv}
        """

rule concat_fg_csv:
    input: 
        fg_MAG = "../results/sourmash/fastgather/{metag}.{outputname}.999.csv",
        fg_gtdb = "../results/sourmash/fastgather/{metag}.{outputname}.gtdb.csv"
    output: 
        csv_concat = "../results/sourmash/fastgather/concat/{metag}.{outputname}.csv"
    params:
        # Use the function to determine the output directory
        outputname=lambda wildcards: get_output_name(wildcards.metag)
    conda: 
        "csvtk"
    shell:
        """
        csvtk concat {input.fg_MAG} {input.fg_gtdb} > {output.csv_concat}
        """

rule concat_db:
    input: 
        picklist = "../results/sourmash/fastgather/concat/{metag}.{outputname}.csv",
        db_MAGs = '../results/sourmash/sketches/MAGs.drep999.zip'
    output: 
        db = "../results/sourmash/fastgather/concat/{metag}.{outputname}.zip"
    params:
        # Use the function to determine the output directory
        outputname=lambda wildcards: get_output_name(wildcards.metag)
    conda: 
        "branchwater"
    shell:
        """
        sourmash sig cat {input.db_MAGs} {GTDB} \
        -k {KSIZE} --picklist {input.picklist}:match_md5:md5 -o {output.db}
        """
rule fastgather_both:
    input:
       sig = lambda wildcards: get_input_file_path(wildcards.metag),
       db = '../results/sourmash/fastgather/concat/{metag}.{outputname}.zip'
    output:
        csv = "../results/sourmash/fastgather_compare/{metag}.{outputname}.999.csv",
    conda: 
        "branchwater"
    threads: 5
    shell:
        """ 
        sourmash scripts fastgather \
        {input.sig} {input.db} \
        -k {KSIZE} --scaled 1000 \
        -c {threads} -o {output.csv}
        """