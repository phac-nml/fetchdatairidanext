process PREFETCH_CHECKER {
    tag "prefetch_checker"
    label 'process_low'

    input:
    val failures  // list of failures

    exec:
    def error_message = "Some samples failed to download!"

    if (failures.size() > 0) {
        failures.each { error_message += "\n\tFAILED: ${it[0].id} -- ${it[1]}" }
        error_message += "\n"
        error error_message
    }
}
