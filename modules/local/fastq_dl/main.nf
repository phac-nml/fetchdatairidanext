process FASTQ_DL {
    tag "$id"
    label 'process_medium'

    conda "bioconda::fastq-dl=3.0.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastq-dl:3.0.0--pyhdfd78af_0' :
        'biocontainers/fastq-dl:3.0.0--pyhdfd78af_0' }"

    input:
    tuple val(meta), val(id)
    val(provider)

    output:
    tuple val(meta), path('reads/*.fastq.gz'), emit: reads
    path "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    """
    # Make directory to move final reads to
    mkdir -p reads

    fastq-dl \\
        $args \\
        --cpus $task.cpus \\
        --provider $provider \\
        --outdir ./ \\
        --accession $id

    # Move/rename reads
    find * -type f   -name "$id*" -exec mv {} reads/${args2}{} \\;

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastq-dl: \$(fastq-dl --version | grep -Eo '[0-9.]+')
    END_VERSIONS
    """
}
