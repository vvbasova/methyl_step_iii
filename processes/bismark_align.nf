process bismark_align {
    tag "$sample_id"
    container params.containers.bismark

    input:
    tuple val(sample_id), path(read1), path(read2)
    path genome_dir

    output:
    tuple val(sample_id), path('*.bam'), emit: bam
    tuple val(sample_id), path('*_PE_report.txt'), emit: report

    script:
    """
    bismark --bowtie2 --genome "${genome_dir}" \\
        --basename "${sample_id}" \\
        -1 "${read1}" -2 "${read2}" \\
        --output_dir .
    """
}
