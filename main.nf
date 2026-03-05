#!/usr/bin/env nextflow

// Main workflow
workflow {

    main:
    // Show workflow parameters before execution
    log.info(
        """
        NBIS support #0000
        ==================
        Input/output options
            Results directory       : ${params.outdir}

        Core Nextflow options
            Work directory          : ${params.workdir}
            Publish mode            : ${params.publish_mode}
            Profile                 : ${workflow.profile}
            Resume                  : ${workflow.resume}
        """)

    // Input channel
    ch_input = channel.of(1, 2, 3)

    // Run workflow
    PROCESS_01(ch_input)

    publish:
    text = PROCESS_01.out.txt

}

// Workflow outputs
output {
    text {
        path { sample, _txt -> "texts/${sample}"}
    }
}

// First process
process PROCESS_01 {
    tag "${input}"

    input:
    val(input)

    output:
    tuple val(input), path("*.txt"), emit: txt

    script:
    """
    echo ${input} > output.txt
    """
}
