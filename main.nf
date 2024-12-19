#!/usr/bin/env nextflow

// Main workflow
workflow {

    // Show workflow parameters before execution
    log.info(
        """
        NBIS support #0000
        ==================
        Input/output options
            Results directory       : ${params.outdir}

        Core Nextflow options
            Work directory          : ${params.workdir}
            Profile                 : ${workflow.profile}
            Resume                  : ${workflow.resume}
        """)

    // Input channel
    ch_input = channel.empty()

    // Run workflow
    PROCESS_01(ch_input)
}

// First process
process PROCESS_01 {
    tag "${input}"
    publishDir "${params.outdir}/",
        mode: params.publish_mode

    input:
    path(input)

    output:
    path("*.txt")

    script:
    """
    touch output.txt
    """
}
