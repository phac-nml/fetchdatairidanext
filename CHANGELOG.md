# phac-nml/fetchdatairidanext: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### `Updated`

- Set nextflow version 25.10.4 to replace 'latest-everything' to confirm compatibility with next IRIDA-Next nextflow version in `.github/workflows` for nf-test. [PR #35](https://github.com/phac-nml/fetchdatairidanext/pull/35)

## [1.3.4] - 2026-03-09

- Added `software_versions.yml` to the `iridanext.output.json.gz` file to track module container updates. [PR #33](https://github.com/phac-nml/fetchdatairidanext/pull/33)
- Move `CUSTOM_SRATOOLSNCBISETTINGS` to a local module, remove from nf-core, and update `sra-toolkit` to `3.2.1`. [PR #33](https://github.com/phac-nml/fetchdatairidanext/pull/33)

## [1.3.3] - 2026-03-06

### `Changed`

- Adding GitHub CI tests against Nextflow `24.10.3`. [PR #28](https://github.com/phac-nml/fetchdatairidanext/pull/28)
- Changed the container for module `SRATOOLS_FASTERQDUMP` to match the nf-core module commit [8e6139dbf4f3ca01bbac6152d2833e04edff18df](https://github.com/nf-core/modules/commit/8e6139dbf4f3ca01bbac6152d2833e04edff18df). [PR #31](https://github.com/phac-nml/fetchdatairidanext/pull/31)
- Migrated the module `SRATOOLS_PREFETCH` from nf-core to local, to resolve some nf-core incompatibilities with `fetchdatairidanext`, and updated the container version to `sra-tools:3.2.1--h4304569_1`. [PR #31](https://github.com/phac-nml/fetchdatairidanext/pull/31)

## [1.3.2] - 2025-02-28

### `Changed`

- Switched `SRATOOLS_FASTERQDUMP` and `FASTQ_DL` resources to `process_medium` to increase resources (storage space) in our deployment for downloading large datasets in [PR #27](https://github.com/phac-nml/fetchdatairidanext/pull/27).

## [1.3.1] - 2025-02-28

### `Changed`

- Switched `SRATOOLS_FASTERQDUMP` process resources from `process_single` to `process_low` to increase resources (storage space) in our deployment for downloading large datasets in [PR #25](https://github.com/phac-nml/fetchdatairidanext/pull/25).

## [1.3.0] - 2025-02-19

### `Added`

- `--provider` parameter to be used to pick where to fetch data from and with what tool in [PR #21](https://github.com/phac-nml/fetchdatairidanext/pull/21).
  - `--provider SRA` fetches data from the Sequence Read Archive
  - `--provider ENA` fetches data from the European Nucleotide Archive

### `Changed`

- Updated `nf-test` snapshots and added new tests for `--provider` feature in [PR #21](https://github.com/phac-nml/fetchdatairidanext/pull/21).
- Updated `nextflow_schema.json` with the `--provider` parameter in [PR #21](https://github.com/phac-nml/fetchdatairidanext/pull/21).
- Updated dependency `fasterq-dump` to version `3.0.8` so that `fasterq-dump` can handle SRA Lite files in addition to SRA files in [PR #23](https://github.com/phac-nml/fetchdatairidanext/pull/23).

## [1.2.0]

### `Changed`

- Modified the template for input csv file to include a `sample_name` column in addition to `sample` in-line with changes to [IRIDA-Next update] as seen with the [speciesabundance pipeline]
  - If `sample_name` is supplied, then the reads will have `sample_name` prefixed before the accession code
  - `sample_name` special characters will be replaced with `"_"`
- Reverted `fasterq-dump` version to 2.11.0 from 3.0.8 due to [issue #865]. Solution proposed by `fetchngs` in [PR #261]
- Fixed linting issues in CI caused by `nf-core` 3.0.1
- Updated `nf-test` snapshots and added new tests for `sample_name` feature

[irida-next update]: https://github.com/phac-nml/irida-next/pull/678
[speciesabundance pipeline]: https://github.com/phac-nml/speciesabundance/pull/24
[issue #865]: https://github.com/ncbi/sra-tools/issues/865
[pr #261]: https://github.com/nf-core/fetchngs/pull/261

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

[1.3.4]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.3.4
[1.3.3]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.3.3
[1.3.2]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.3.2
[1.3.1]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.3.1
[1.3.0]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.3.0
[1.2.0]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.2.0
[1.1.1]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.1.1
[1.1.0]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.1.0
[1.0.1]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.0.1
[1.0.0]: https://github.com/phac-nml/fetchdatairidanext/releases/tag/1.0.0
