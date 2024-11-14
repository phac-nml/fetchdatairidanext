# phac-nml/fetchdatairidanext: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0]

### `Changed`

- Modified the template for input csv file to include a `sample_name` column in addition to `sample` in-line with changes to [IRIDA-Next update] as seen with the [speciesabundance pipeline]
  - `sample_name` special characters will be replaced with `"_"`
  - If no `sample_name` is supplied in the column `sample` will be used
  - To avoid repeat values for `sample_name` all `sample_name` values will be suffixed with the unique `sample` value from the input file

[IRIDA-Next update]: https://github.com/phac-nml/irida-next/pull/678
[speciesabundance pipeline]: https://github.com/phac-nml/speciesabundance/pull/24

## [1.1.1] - 2024-04-19

### Added

### Changed

- Switched the resource label for **prefetchchecker** from `process_low` to `process_single`.
- Switched GitHub continuous integration to test against at most Nextflow `23.10.1` (due to differences in outputs with later Nextflow pre-releases).

## [1.1.0] - 2024-04-10

### Added

- The ability to handle individual download errors. These errors will be reported in `prefetch/failures_report.csv`.

## [1.0.1] - 2024-02-22

### Changed

- Pinned nf-validation (@1.1.3) and nf-iridanext (@0.2.0) plugins to specific versions in nextflow.config

## [1.0.0] - 2024-01-26

### Added

- Initial release of fetchdatairidanext pipeline which will download reads from NCBI/INSDC archives.
