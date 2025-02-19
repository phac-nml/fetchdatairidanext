include { FASTQ_DL          } from '../../../modules/local/fastq_dl/main'
include { PREFETCH_CHECKER  } from '../../../modules/local/prefetchchecker/main'

//
// Download FASTQ sequencing reads from ENA with fastq-dl
//
workflow FASTQ_DOWNLOAD_FASTQ_DL {
    take:
    ch_ids   // channel: [ val(meta), val(id) ]

    main:

    ch_versions = Channel.empty()

    //
    // Fetch sequencing reads in FASTQ and SRA format.
    //
    FASTQ_DL ( ch_ids, params.provider )
    ch_versions = ch_versions.mix(FASTQ_DL.out.versions.first())

    //
    // Check and report failures
    //
    ch_ids.join(FASTQ_DL.out.reads, remainder: true)
        .filter { it[2] == null }
        .toList()
        .set { failed_fetches }

    PREFETCH_CHECKER (failed_fetches)

    emit:
    reads    = FASTQ_DL.out.reads   // channel: [ val(meta), [ reads ] ]
    versions = ch_versions          // channel: [ versions.yml ]
}
