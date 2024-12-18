# NBIS Support \#0000-short-title

This is the home of the NBIS support project _"Long title, as appearing on e.g.
Redmine"_.

## Project organisation

```bash
project/
 ├── bin/                   Scripts and executables
 ├── data/                  Data
 ├── doc/                   Documents and other information
 ├── env/                   Environment-related files
 │   ├── Dockerfile           Docker image specification
 │   ├── pixi.toml            Pixi environment file
 │   └── pixi.lock            Pixi lockfile
 ├── results/               Workflow results
 ├── main.nf                Workflow definition
 ├── nextflow.config        Workflow configuration
 └── README.md              Project and repository overview
```

## Reproducibility

The project is contained within a Nextflow-based workflow, which can use either
Docker (preferred method) or Pixi to facilitate reproducibility of all the
analyses. Historic runs corresponding to previous results can be found in the
repository's tags, which can be listed using `git tag`. Raw data is not stored
in this repository.

### Using Docker

```bash
# Run the workflow
nextflow run main.nf -profile docker
```

### Using Pixi

```bash
# Create and activate the Pixi shell
cd env
pixi install
pixi shell

# Run the workflow
nextflow run main.nf
```
