import os

configfile: "config.yaml"

rule all:
    input:
        config["result_dir"] + "/taxonomy/kraken_report.txt"


rule basecalling:
    input:
        config['fast5_dir']
    output:
        config["result_dir"] + "/fastq"
    params:
        call_config = config["caller"]["config"],
        call_chunks = config["caller"]["chunks"]
    shell:
        "guppy_basecaller --recursive --input_path {input} --save_path {output} --config {params.call_config} --chunks_per_runner {params.call_chunks} --device 'auto'"


rule combine_and_compress_fastq:
    input:
        rules.basecalling.output
    output:
        config["result_dir"] + "/aggregate.fastq.gz"
    shell:
        'cat {input}/pass/*fastq | gzip > {output}'


# CAN'T be run on metacenter within snakemake
#rule plots:
#    input:
#        config["fastq_dir"] + "/sequencing_summary.txt"
#    output:
#        config["seq_plot"]
#    shell:
#        "NanoPlot -o {output} --summary {input}"


rule filtering:
    input:
        rules.combine_and_compress_fastq.output
    output:
        config["result_dir"] + "/trimed.fastq.gz"
    run:
        shell("porechop-runner.py -i {input} -o {output}")
        #shell("porechop-runner.py -i {input} -b {output_dir}")     #DEMULTIPLEXING


rule kraken_taxonomy:
    input:
        rules.filtering.output
    output:
        config["result_dir"] + "/taxonomy/kraken_report.txt"
    params:
        db = config["kraken_db"]
    shell:
        "kraken2 --db {params.db} --threads 24 --report {output} --gzip-compressed {input}"