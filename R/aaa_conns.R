sc_conn <- function() {
  check_vars()
  sparklyr::spark_connect(
    master = Sys.getenv("DATABRICKS_HOST"),
    cluster_id = Sys.getenv("DATABRICKS_CLUSTER_ID"),
    token = Sys.getenv("DATABRICKS_TOKEN"),
    envname = Sys.getenv("DATABRICKS_VENV"),
    app_name = "sconn_sparklyr",
    method = "databricks_connect"
  )
}

.onLoad <- function(...) {
  .conns <<- rlang::new_environment()
  rlang::env_bind_lazy(.conns, sc = sc_conn())
}
