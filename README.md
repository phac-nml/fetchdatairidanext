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
* **sample**: The sample identifier downloaded read data should be associated with.
* **insdc_accession**: The accession from the [International Sequence Data Collaboration (INSDC)][insdc] for the data to download (currently only sequence runs supported, e.g., starting with `SRR` or `ERR`).

The structure of this file is defined in [assets/schema_input.json](assets/schema_input.json). An example of this file is provided at [assets/samplesheet.csv](assets/samplesheet.csv).

# Parameters

The main parameters are `--input` as defined above and `--output` for specifying the output results directory. You may wish to provide `-profile singularity` to specify the use of singularity containers (or `-profile docker` for docker) and `-r [branch]` to specify which GitHub branch you would like to run.

Other parameters (defaults from nf-core) are defined in [nextflow_schema.json](nextflow_schema.json).

# Running

## Test data

To run the pipeline with test data, please do:

```bash
nextflow run phac-nml/fetchdatairidanext -profile test,singularity --outdir results
```

The downloaded data will appear in `results/`. A JSON file for integrating data with IRIDA Next will be written to `results/iridanext.output.json.gz` (see the [Output](#output) section for details).

## Other data

To run the pipeline with other data (a custom samplesheet), please do:

```bash
nextflow run phac-nml/fetchdatairidanext -profile singularity --input assets/samplesheet.csv --outdir results
```

Where the `samplesheet.csv` is structured as specified in the [Input](#input) section.

# Output

## Read data

The sequence reads will appear in the `results/sratools/reads` directory (assuming `--outdir results` is specified). For example:

```
results/sratools/reads/
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
            "SampleA": [
                {"path": "sratools/reads/SRR13191702_1.fastq.gz"},
                {"path": "sratools/reads/SRR13191702_2.fastq.gz"}
            ],
        }
    }
}
```

Within the `files` section of this JSON file, all of the output paths are relative to the `--outdir results`. Therefore, `"path": "sratools/reads/SRR13191702_1.fastq.gz"` refers to a file located within `results/sratools/reads/SRR13191702_1.fastq.gz`.

An additional example of this file can be found at [tests/data/test1_iridanext.output.json](tests/data/test1_iridanext.output.json).

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
