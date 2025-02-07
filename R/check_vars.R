#' Check all required environment variables are not empty
#' @keywords internal
check_vars <- function() {
  check_var <- function(var_name) {
    val_value <- Sys.getenv(var_name)
    if (is.na(val_value) || val_value == "") {
      cli::cli_alert_danger("The variable {.var {var_name}} is not set.")
      invisible(FALSE)
    } else {
      invisible(TRUE)
    }
  }
  vars <- paste0("DATABRICKS_", c("HOST", "CLUSTER_ID", "TOKEN", "VENV"))
  invisible(all(vapply(vars, check_var, logical(1L))))
}
