#!/usr/bin/env nextflow

include { QUARTO_PRERENDER as PRERENDER } from "./modules/nf-core/quarto/prerender"
include { QUARTO_NOTEBOOK as REPORT     } from "./modules/nf-core/quarto/notebook"

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

    // Pre-render notebooks
    prerender_notebook = file("${projectDir}/bin/prerender.qmd", checkIfExists: true)
    ch_prerender_notebook = [[id: prerender_notebook.simpleName], prerender_notebook]
    ch_prerender_params = []
    ch_prerender_input = ch_input.map { _meta, txt -> txt }.collect()
    PRERENDER (
        ch_prerender_notebook,
        ch_prerender_params,
        ch_prerender_input
    )

    // Final Quarto render, including all pre-rendered notebooks
    report_notebook = file("${projectDir}/bin/report.qmd", checkIfExists: true)
    extensions = file("${projectDir}/assets/_extensions", checkIfExists: true)
    ch_report_notebook = [[id: report_notebook.simpleName], report_notebook]
    ch_report_params = []
    ch_report_input = PRERENDER.out.rendered
        .map { _meta, prerender -> prerender }
        .collect()
    REPORT (
        ch_report_notebook,
        ch_report_params,
        ch_report_input,
        extensions
    )

    // Collect all artefacts
    ch_artifacts = PRERENDER.out.artifacts.mix(REPORT.out.artifacts)

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
