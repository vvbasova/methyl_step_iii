#!/usr/bin/env nextflow

include { fastqc          } from './processes/fastqc'
include { trim_galore     } from './processes/trim_galore'
include { prepare_genome  } from './processes/prepare_genome'
include { bismark_align   } from './processes/bismark_align'
include { bismark_dedup   } from './processes/bismark_dedup'
include { bismark_extract } from './processes/bismark_extract'
include { bismark_report  } from './processes/bismark_report'
include { multiqc         } from './processes/multiqc'

workflow {
    main:

    reads_ch = channel.fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            tuple(
                row.sample_id,
                file(row.fastq_1),
                file(row.fastq_2)
            )
        }

    genome_fasta_ch = channel.value(file(params.reference_fasta))

    fastqc(reads_ch)
    trim_galore(reads_ch)
    prepare_genome(genome_fasta_ch)
    bismark_align(trim_galore.out.reads, prepare_genome.out.genome)
    bismark_dedup(bismark_align.out.bam)
    bismark_extract(bismark_dedup.out.bam, prepare_genome.out.genome)

    bismark_report_inputs_ch = bismark_align.out.report
        .join(bismark_dedup.out.report)
        .join(bismark_extract.out.splitting_report)
        .join(bismark_extract.out.mbias)

    bismark_report(bismark_report_inputs_ch)

    multiqc_inputs_ch = fastqc.out.zip
        .mix(trim_galore.out.report)
        .mix(bismark_align.out.report)
        .mix(bismark_dedup.out.report)
        .mix(bismark_extract.out.splitting_report)
        .mix(bismark_extract.out.mbias)
        .map { _sample, report_files -> report_files }
        .flatten()
        .collect()

    multiqc(multiqc_inputs_ch)

    fastqc_results_ch = fastqc.out.html.mix(fastqc.out.zip)
    methylation_results_ch = bismark_extract.out.coverage
        .mix(bismark_extract.out.bedgraph)
        .mix(bismark_extract.out.cpg_report)
    extraction_qc_ch = bismark_extract.out.splitting_report
        .mix(bismark_extract.out.mbias)

    publish:
    fastqc          = fastqc_results_ch
    trimming        = trim_galore.out.report
    alignment       = bismark_align.out.report
    deduplication   = bismark_dedup.out.report
    bam             = bismark_dedup.out.bam
    methylation     = methylation_results_ch
    extraction_qc   = extraction_qc_ch
    bismark_report  = bismark_report.out.html
    multiqc         = multiqc.out.html
}


output {
    fastqc         { path 'fastqc'                }
    trimming       { path 'reports/trimming'      }
    alignment      { path 'reports/alignment'     }
    deduplication  { path 'reports/deduplication' }
    bam            { path 'bam'                   }
    methylation    { path 'methylation'           }
    extraction_qc  { path 'reports/extraction'    }
    bismark_report { path 'reports/bismark'       }
    multiqc        { path 'multiqc'               }
}
