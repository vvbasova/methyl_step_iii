process fastqc {
    tag "$sample_id"
    container params.containers.fastqc

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id), path('*_fastqc.html'), emit: html
    tuple val(sample_id), path('*_fastqc.zip'),  emit: zip

    script:
    """
    fastqc --threads ${task.cpus}  "${read1}" "${read2}"
    """
}
