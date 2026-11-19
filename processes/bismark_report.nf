process bismark_report {
    tag "$sample_id"
    container params.containers.bismark

    input:
    tuple val(sample_id), path(alignment_report), path(dedup_report),
          path(splitting_report), path(mbias_report)

    output:
    tuple val(sample_id), path("${sample_id}_bismark_report.html"), emit: html

    script:
    """
    bismark2report \\
        --alignment_report "${alignment_report}" \\
        --dedup_report "${dedup_report}" \\
        --splitting_report "${splitting_report}" \\
        --mbias_report "${mbias_report}" \\
        --output "${sample_id}_bismark_report.html"
    """
}
