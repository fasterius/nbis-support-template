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
    partial_notebook = file("${projectDir}/bin/partial.qmd", checkIfExists: true)
    ch_partial_notebook = [[id: partial_notebook.simpleName], partial_notebook]
    ch_partial_params = [ artifact_dir: "artifacts" ]
    ch_partial_input = ch_input.map { _meta, txt -> txt }.collect()
    PARTIAL (
        ch_partial_notebook,
        ch_partial_params,
        ch_partial_input
    )

    // Final Quarto render, including all partials
    report_notebook = file("${projectDir}/bin/report.qmd", checkIfExists: true)
    extensions = file("${projectDir}/assets/_extensions", checkIfExists: true)
    ch_report_notebook = [[id: report_notebook.simpleName], report_notebook]
    ch_report_params = [ artifact_dir: "artifacts" ]
    ch_report_input = PARTIAL.out.partial
        .map { _meta, partial -> partial }
        .collect()
    REPORT (
        ch_report_notebook,
        ch_report_params,
        ch_report_input,
        extensions
    )

    // Collect all artefacts
    ch_artifacts = PARTIAL.out.artifacts.mix(REPORT.out.artifacts)

    publish:
    html      = REPORT.out.html
    artifacts = ch_artifacts
}

// Workflow outputs
output {
    html {
        path { "reports/" }
    }
    artifacts {
    }
}
