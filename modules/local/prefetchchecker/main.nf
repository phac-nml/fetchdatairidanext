process PREFETCH_CHECKER {
    tag "prefetch_checker"
    label 'process_single'

    input:
    val failures  // list of failures

    output:
    path("failures_report.csv"), emit: failure_report

    exec:
    task.workDir.resolve("failures_report.csv").withWriter { writer ->

        writer.writeLine("sample,error_accession")  // header

        // Failures
        if (failures.size() > 0) {
            failures.each { writer.writeLine "${it[0].id},${it[1]}" }
        }
    }
}
