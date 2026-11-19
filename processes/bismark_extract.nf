process bismark_extract {
    tag "$sample_id"
    container params.containers.bismark

    input:
    tuple val(sample_id), path(bam)
    path genome_dir

    output:
    tuple val(sample_id), path('*.bismark.cov.gz'), emit: coverage
    tuple val(sample_id), path('*.bedGraph.gz'), emit: bedgraph
    tuple val(sample_id), path('*.CpG_report.txt.gz'), emit: cpg_report
    tuple val(sample_id), path('*_splitting_report.txt'), emit: splitting_report
    tuple val(sample_id), path('*.M-bias.txt'), emit: mbias

    script:
    """
    bismark_methylation_extractor \\
        --paired-end --no_overlap --gzip \\
        --bedGraph --cytosine_report \\
        --genome_folder "${genome_dir}" \\
        "${bam}"
    """
}
