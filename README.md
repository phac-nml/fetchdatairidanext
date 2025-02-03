[![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A523.04.3-brightgreen.svg)](https://www.nextflow.io/)

# fetchdatairidanext pipeline

This pipeline can be used to fetch data from NCBI for integration into [IRIDA Next][irida-next].

# Input

The input to the pipeline is a standard sample sheet (passed as `--input samplesheet.csv`) that looks like:

| sample  | insdc_accession |
| ------- | --------------- |
| SampleA | ERR1109373      |
| SampleB | SRR13191702     |

That is, there are two columns:

- **sample**: The sample identifier downloaded read data should be associated with.
- **insdc_accession**: The accession from the [International Sequence Data Collaboration (INSDC)][insdc] for the data to download (currently only sequence runs supported, e.g., starting with `SRR`, `ERR`, or `DRR`).

The structure of this file is defined in [assets/schema_input.json](assets/schema_input.json). An example of this file is provided at [assets/samplesheet.csv](assets/samplesheet.csv).

## IRIDA-Next Optional Input Configuration

`fetchdatairidanext` accepts the [IRIDA-Next](https://github.com/phac-nml/irida-next) format for samplesheets which can contain an additional column: `sample_name`

`sample_name`: An **optional** column, to add the `sample_name` prefix before the accession code.

`sample_name`, allows more flexibility in naming reads. Unlike `sample`, `sample_name` is not required to contain unique values. Non-alphanumeric characters (excluding `_`,`-`,`.`) will be replaced with `"_"`. `sample_name` can be provided without renaming by changing parameters.

An [example samplesheet](tests/data/samplesheets/samplesheet-sample_name.csv) has been provided with the pipeline.

# Parameters

The main parameters are `--input` as defined above and `--output` for specifying the output results directory. You may wish to provide `-profile singularity` to specify the use of singularity containers (or `-profile docker` for docker) and `-r [branch]` to specify which GitHub branch you would like to run.

`--rename_with_samplename` (Default: `true`) When `false`, samplesheet column `sample_name` not used for reads-renaming.

`--provider ['SRA'|'ENA']` (Default: `SRA`) When using `SRA`, the data will be pulled with [`sra-tools fasterq-dump`](https://github.com/ncbi/sra-tools) and when using `ENA`, the data will be pulled with [`fastq-dl`](https://github.com/rpetit3/fastq-dl)

Other parameters (defaults from nf-core) are defined in [nextflow_schema.json](nextflow_schema.json).

# Running

## Test data

To run the pipeline with test data, please do:

```bash
nextflow run phac-nml/fetchdatairidanext -profile test,docker --outdir results
```

The downloaded data will appear in `results/`. A JSON file for integrating data with IRIDA Next will be written to `results/iridanext.output.json.gz` (see the [Output](#output) section for details).

## Other data

To run the pipeline with other data (a custom samplesheet), please do:

```bash
nextflow run phac-nml/fetchdatairidanext -profile docker --input assets/samplesheet.csv --outdir results
```

Where the `samplesheet.csv` is structured as specified in the [Input](#input) section.

# Output

## Read data

The sequence reads will appear in the `results/reads` directory (assuming `--outdir results` is specified). For example:

```
results/reads/
├── ERR1109373.fastq.gz
├── ERR1109373_1.fastq.gz
├── ERR1109373_2.fastq.gz
├── SRR13191702_1.fastq.gz
└── SRR13191702_2.fastq.gz
```

## IRIDA Next integration file

A JSON file for loading the data into IRIDA Next is output by this pipeline. The format of this JSON file is specified in our [Pipeline Standards for the IRIDA Next JSON](https://github.com/phac-nml/pipeline-standards#32-irida-next-json). This JSON file is written directly within the `--outdir` provided to the pipeline with the name `irida.output.json.gz` (ex: `[outdir]/irida.output.json.gz`).

```json
{
  "files": {
    "global": [],
    "samples": {
      "SampleA": [{ "path": "reads/SRR13191702_1.fastq.gz" }, { "path": "reads/SRR13191702_2.fastq.gz" }]
    }
  }
}
```

Within the `files` section of this JSON file, all of the output paths are relative to the `--outdir results`. Therefore, `"path": "reads/SRR13191702_1.fastq.gz"` refers to a file located within `sratools/reads/SRR13191702_1.fastq.gz`.

An additional example of this file can be found at [tests/data/test1_iridanext.output.json](tests/data/test1_iridanext.output.json).

## Failures

If one or more samples fail to download, the workflow will still attempt to download all other samples in the samplesheet. The samples that fail to download will be reported in a file named `results/prefetch/failures_report.csv`. This CSV file has two columns: `sample` (the name of the sample, matching the input samplesheet) and `error_accession` (the accession that failed to download).

For example:

```
sample,error_accession
ERROR1,SRR999908
ERROR2,SRR999934
```

# Acknowledgements

This pipeline uses code and infrastructure developed and maintained by the [nf-core][nf-core] initative, and reused here under the [MIT license](https://github.com/nf-core/tools/blob/master/LICENSE).

> The nf-core framework for community-curated bioinformatics pipelines.
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> Nat Biotechnol. 2020 Feb 13. doi: 10.1038/s41587-020-0439-x.

In addition, references of tools and data used in this pipeline are as follows:

- The [fastq_download_prefetch_fasterqdump_sratools](https://nf-co.re/subworkflows/fastq_download_prefetch_fasterqdump_sratools) subworkflow from nf-core. Custom modifications to this workflow (and underlying modules) are found in the [subworkflows/local](subworkflows/local) and [modules/local](modules/local) directories.

- The [fastq-dl tool](https://github.com/rpetit3/fastq-dl) for grabbing data from the ENA.

Other works this pipeline makes use of are found in the [CITATIONS.md](CITATIONS.md) file.

# Legal

Copyright 2024 Government of Canada

Licensed under the MIT License (the "License"); you may not use
this work except in compliance with the License. You may obtain a copy of the
License at:

https://opensource.org/license/mit/

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

[irida-next]: https://github.com/phac-nml/irida-next
[insdc]: https://www.insdc.org/
[nf-core]: https://nf-co.re/
