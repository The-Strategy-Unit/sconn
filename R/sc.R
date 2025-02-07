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
  if (is.null(get0("sc_conn", .conns))) {
    rlang::env_bind_lazy(.conns, sc_conn = sc_conn())
  }
  sc <- get0("sc_conn", .conns)
  if (hide_output) invisible(sc) else sc
}


#' Disconnect Databricks connection
#'
#' If the connection object exists in the `.conns` environment, disconnect it.
#'
#' @returns TRUE if successful
#' @export
sc_disconnect <- function() {
  if (is.null(get0("sc_conn", .conns))) {
    cli::cli_alert_info("sc_disconnect: No Spark connection found.")
    res <- TRUE
  } else {
    sc <- get0("sc_conn", .conns)
    res <- tryCatch(sparklyr::spark_disconnect(sc), error = \(e) FALSE)
    rlang::env_unbind(.conns, "sc_conn")
  }
  rlang::env_bind_lazy(.conns, sc_conn = sc_conn())
  invisible(res %||% TRUE)
}
