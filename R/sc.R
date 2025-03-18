#' Poke or initiate Databricks connection
#'
#' Should check if connection object already exists in the `.conns`
#'  environment, and if so use it. If no connection found, it should initiate
#'  the connection, and bind it to the `.conns` environment.
#'
#' @param hide_output logical. Hide the output of spark_connect(). Default TRUE
#' @returns The connection object, activating the connection
#' @export
sc <- function(hide_output = TRUE) {
  if (!rlang::env_has(.conns, "sc")) {
    rlang::env_bind_lazy(.conns, sc = sc_conn())
  }
  sc <- rlang::env_get(.conns, "sc", default = NULL)
  if (hide_output) invisible(sc) else sc
}


#' Disconnect Databricks connection
#'
#' If the connection object exists in the `.conns` environment, disconnect it.
#'
#' @returns TRUE if successful
#' @export
sc_disconnect <- function() {
  if (rlang::env_has(.conns, "sc")) {
    res <- tryCatch(sparklyr::spark_disconnect(.conns$sc), error = \(e) FALSE)
    rlang::env_unbind(.conns, "sc")
    rlang::env_bind_lazy(.conns, sc = sc_conn())
  } else {
    cli::cli_alert_info("sc_disconnect: No Spark connection found.")
    res <- TRUE
  }
  invisible(res %||% TRUE)
}
