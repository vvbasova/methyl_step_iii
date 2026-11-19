process multiqc {
    container params.containers.multiqc

    input:
    path report_files

    output:
    path 'multiqc_report.html', emit: html

    script:

    """
    multiqc --force --filename multiqc_report.html --outdir . .
    """
}
