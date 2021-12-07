# NBIS Support \#0000-short-title

This is the home of the NBIS support project *"Long title, as appearing on e.g.
Redmine"*.

## Project organisation

```bash
project/
 ├── bin/                   Scripts and executables
 ├── data/                  Data
 ├── doc/                   Documents and other information
 ├── env/
 │   ├── Dockerfile         Docker image specification
 │   └── environment.yml    Conda environment file
 ├── results/               Workflow results
 ├── main.nf                Workflow definition
 ├── nextflow.config        Workflow configuration
 └── README.md              Project and repository overview
```

## Reproducibility

The project is contained within a Nextflow-based workflow, which can use either
Conda or Docker to facilitate reproducibility of all the analyses. Historic runs
corresponding to previous results can be found in the repository's tags, which
can be listed using `git tag`. Raw data is not stored in this repository.

### Using Docker

```bash
# Build the Docker image
docker build -t nbis-0000 -f Dockerfile .

# Run the workflow
nextflow run main.nf -use-docker nbis-0000
```

### Using Conda

```bash
# Create and activate the Conda environment
conda env create -p 0000-env -f environment.yml
conda activate 0000-env/

# Run the workflow
nextflow run main.nf
```
