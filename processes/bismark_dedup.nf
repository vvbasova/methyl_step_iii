process bismark_dedup {
    tag "$sample_id"
    container params.containers.bismark

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path('*.deduplicated.bam'), emit: bam
    tuple val(sample_id), path('*.deduplication_report.txt'), emit: report

    script:
    """
    deduplicate_bismark --paired --bam "${bam}"
    """
}
