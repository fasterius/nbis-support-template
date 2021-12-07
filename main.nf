#!/usr/bin/env nextflow

// Enable DSL2 syntax
nextflow.enable.dsl = 2

// Default parameters (can be overridden in `nextflow.config`)
params.resultsdir = "results/"
params.workdir = "work/"
params.publish_mode = "copy"

// Show workflow parameters before execution
log.info("""
    NBIS support #0000
    ==================

    Workflow parameters
        Results directory       : ${params.resultsdir}
        Work directory          : ${params.workdir}
        Resume                  : ${workflow.resume}
        Profile                 : ${workflow.profile}
    """)

// Main workflow
workflow {
    // Run workflow
    PROCESS_01(ch_input)
}

// First process
process PROCESS_01 {
    tag "${input}"
    publishDir "${params.resultsdir}/",
        mode: params.publish_mode

    input:
    path(ch_input)

    output:
    path("output_01")

    script:
    """
    touch output_01
    """
}
