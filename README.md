# NBIS Support \#0000-short-title

This is the home of the NBIS support project _"Long title, as appearing on e.g.
Redmine"_.

## Project organisation

```bash
project/
 ├── bin/                   Scripts and executables
 ├── data/                  Data
 ├── doc/                   Documents and other information
 ├── results/               Workflow results
 ├── main.nf                Workflow definition
 ├── nextflow.config        Workflow configuration
 ├── README.md              Project overview and documentation
 ├── pixi.toml              Pixi environment file
 └── pixi.lock              Pixi lockfile
```

## Reproducibility

The project is contained within a Nextflow-based workflow, which uses Pixi and
Docker to facilitate reproducibility of all the analyses; Pixi controls the
version of Nextflow and Docker everything else. Historic runs corresponding to
previous results can be found in the repository's tags, which can be listed
using `git tag`. Raw data is not stored in this repository.

```bash
pixi run nextflow run main.nf -profile docker
```

You can also use any of the [nf-core configurations](https://nf-co.re/configs)
by adding _e.g._ `profile docker,pdc_kth` (for running on Dardel @ PDC).
