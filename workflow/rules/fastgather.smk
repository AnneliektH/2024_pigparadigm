rule fastgather_h:
# works
    input:
       sig= "/group/ctbrowngrp/irber/data/wort-data/wort-sra/sigs/{metag_h}.sig",
    output:
        csv = "../results/sourmash/fastgather/{metag_h}.human.gtdb.csv",
    conda: 
        "branchwater"
    threads: 12
    shell:
        """ 
        sourmash scripts fastgather \
        {input.sig} {GTDB} \
        -k 21 --scaled 1000 \
        -c {threads} -o {output.csv}
        """

rule fastgather_p:
# works
    input:
       sig= "../results/sourmash/sketches/read_s100/{metag_p}.sig.gz",
    output:
        csv = "../results/sourmash/fastgather/{metag_p}.pig.gtdb.csv",
    conda: 
        "branchwater"
    threads: 10
    shell:
        """ 
        sourmash scripts fastgather \
        {input.sig} {GTDB} \
        -k 21 --scaled 1000 \
        -c {threads} -o {output.csv}
        """