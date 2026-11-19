process prepare_genome {
    container params.containers.bismark

    input:
    path genome_fasta

    output:
    path 'genome', emit: genome

    script:
    def unpack = genome_fasta.name.endsWith('.gz') ?
        "gzip -cd \"${genome_fasta}\" > genome/reference.fa" :
        "cp \"${genome_fasta}\" genome/reference.fa"
    """
    mkdir -p genome
    ${unpack}
    bismark_genome_preparation --bowtie2 genome
    """
}
