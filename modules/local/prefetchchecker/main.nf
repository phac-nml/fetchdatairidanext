process PREFETCH_CHECKER {
    tag "prefetch_checker"
    label 'process_single'

    input:
    val failures  // list of failures

    output:
    path("failures_report.csv"), emit: failure_report

    exec:
    task.workDir.resolve("failures_report.csv").withWriter { writer ->

        sample_name = false
        failures.each { if ( it[0].id != null) {
            sample_name = true
        }
        }

        // Failures
        if (failures.size() > 0 && sample_name) {
            writer.writeLine("sample,sample_name,error_accession")  // header
            failures.each { writer.writeLine "${it[0].irida_id},${it[0].id},${it[1]}" }
        } else {
            writer.writeLine("sample,error_accession")  // header
            failures.each { writer.writeLine "${it[0].irida_id},${it[1]}" }
        }
    }
}
