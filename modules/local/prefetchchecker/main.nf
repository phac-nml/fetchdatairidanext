process PREFETCH_CHECKER {
    tag "prefetch_checker"
    label 'process_low'

    input:
    val failures  // list of failures

    output:
    path("failures_report.csv"), emit: failure_report

    exec:
    def failure_report_path = [task.workDir, "failures_report.csv"].join(File.separator)
    println failure_report_path
    ///*
    new File(failure_report_path).withWriter { writer ->
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
    //*/
}
