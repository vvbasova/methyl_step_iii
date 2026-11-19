process trim_galore {
    tag "$sample_id"
    container params.containers.trim_galore

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id), path('*_val_1.fq.gz'), path('*_val_2.fq.gz'), emit: reads
    tuple val(sample_id), path('*_trimming_report.txt'), emit: report

    script:
    """
    trim_galore --paired --gzip --cores ${task.cpus} --output_dir . "${read1}" "${read2}"
    """
}
