#!/usr/bin/env nextflow

include { QUARTONOTEBOOK as REPORT } from "./modules/nf-core/quartonotebook"

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
            Publish mode            : ${params.publish_dir_mode}
            Profile                 : ${workflow.profile}
            Resume                  : ${workflow.resume}
        """
    )

    // Input channel on the format of [meta, sample]
    ch_input = channel.fromPath("data/test.txt", checkIfExists: true)
        .map { it -> [[id: it.baseName], it] }

    // Run workflow
    report_notebook = file("${projectDir}/bin/report.qmd", checkIfExists: true)
    extensions = file("${projectDir}/assets/_extensions", checkIfExists: true)
    ch_report_input_data = ch_input
        .map { it -> it[1] }
    ch_report_notebook = ch_input
        .map { it -> it[0] }
        .combine(channel.value(report_notebook))
        .map { meta, notebook -> tuple(meta, notebook) }
    ch_report_params = ch_input
        .map { _meta, _sample ->
            [
                artifact_dir : "artifacts"
            ]
        }
    REPORT (
        ch_report_notebook,
        ch_report_params,
        ch_report_input_data,
        extensions
    )

    publish:
    html    = REPORT.out.html
    figures = REPORT.out.artifacts

}

// Workflow outputs
output {
    html {
        path { "reports/"}
    }
    figures {
        path { "reports/figures"}
    }
}
