process SRATOOLS_FASTERQDUMP {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-5f89fe0cd045cb1d615630b9261a1d17943a9b6a:2f4a4c900edd6801ff0068c2b3048b4459d119eb-0' :
        'biocontainers/mulled-v2-5f89fe0cd045cb1d615630b9261a1d17943a9b6a:2f4a4c900edd6801ff0068c2b3048b4459d119eb-0' }"

    input:
    tuple val(meta), path(sra)
    path ncbi_settings
    path certificate

    output:
    tuple val(meta), path('reads/*.fastq.gz'), emit: reads
    path "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    def args3 = task.ext.args3 ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def key_file = ''

    if (certificate.toString().endsWith('.jwt')){
        key_file += " --perm ${certificate}"
        }
    else if (certificate.toString().endsWith('.ngc')){
        key_file += " --ngc ${certificate}"
    }

    """
    export NCBI_SETTINGS="\$PWD/${ncbi_settings}"

    # Make directory ahead of time since otherwise
    # fasterq-dump does not set correct permissions/owner
    mkdir -p reads

    fasterq-dump \\
        $args \\
        --threads $task.cpus \\
        --outdir reads \\
        ${key_file} \\
        ${sra}

    find reads/ -type f   -name "$args2" -exec mv {} {}.fastq \\;

    pigz \\
        $args3 \\
        --no-name \\
        --processes $task.cpus \\
        reads/*.fastq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sratools: \$(fasterq-dump --version 2>&1 | grep -Eo '[0-9.]+')
        pigz: \$( pigz --version 2>&1 | sed 's/pigz //g' )
    END_VERSIONS
    """
}
