process PREFETCH_CHECKER {
    tag "prefetch_checker"
    label 'process_low'

    input:
    val failures  // list of failures

    output:
    path("failures_report.csv"), emit: failure_report

    exec:
    task.workDir.resolve("failures_report.csv").withWriter { writer ->
        // Failures
        if (failures.size() > 0) {
            failures.each { writer.writeLine "${it[0].id},${it[1]}" }
        }
        // No failures
        else
        {
            writer.write("")  // create the file by writing an empty line
        }
    }
}
