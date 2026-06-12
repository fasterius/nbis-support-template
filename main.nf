#!/usr/bin/env nextflow

include { QUARTO_PARTIAL as PARTIAL } from "./modules/local/quarto/partial"
include { QUARTONOTEBOOK as REPORT  } from "./modules/nf-core/quartonotebook"

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

    // Render Quarto partials
    partial_notebook = file("${projectDir}/bin/_partial.qmd", checkIfExists: true)
    ch_partial_input = ch_input.map { it -> it[1] }
    ch_partial_notebook = ch_input
        .map { it -> it[0] }
        .combine(channel.value(partial_notebook))
        .map { meta, notebook -> tuple(meta, notebook) }
    ch_partial_params = ch_input
        .map { _meta, _sample -> [ artifact_dir : "artifacts" ] }
    PARTIAL (
        ch_partial_notebook,
        ch_partial_params,
        ch_partial_input
    )

    // Final Quarto render, including all partials
    report_notebook = file("${projectDir}/bin/report.qmd", checkIfExists: true)
    extensions = file("${projectDir}/assets/_extensions", checkIfExists: true)
    ch_report_input = PARTIAL.out.partial
        .mix(PARTIAL.out.partial_files)
        .map { _meta, qmd -> qmd }
        .collect()
    ch_report_notebook = PARTIAL.out.partial
        .map { it -> it[0] }
        .combine(channel.value(report_notebook))
        .map { meta, notebook -> tuple(meta, notebook) }
    ch_report_params = PARTIAL.out.partial
        .map { _meta, _sample -> [ artifact_dir : "artifacts" ] }
    REPORT (
        ch_report_notebook,
        ch_report_params,
        ch_report_input,
        extensions
    )

    publish:
    html    = REPORT.out.html
    figures = REPORT.out.artifacts

}

// Workflow outputs
output {
    html {
        path { "reports/" }
    }
    figures {
        path { "reports/figures"}
    }
}
