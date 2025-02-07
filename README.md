# sconn

A very simple package that provides a function to connect to a
  Databricks instance, and a function to disconnect.
The user should set up Databricks authentication details as environment
  variables, ideally in their `.Renviron` file.

## Installation

```r
remotes::install_github("The-Strategy-Unit/sconn")
```

Once installed, there are some initial setup steps to complete before using the
  connection function for the first time. See below.

## Quick usage

```r
library(sconn)
sc()
sc_disconnect()
```

## Setup: Environment variables

The connection function requires four environment variables to be available.

The best method for doing this is to add them to your main `.Renviron` file,
  which is read in automatically by R each time it starts.
  You can alternatively store them in a per-project `.Renviron` file.

To edit your main `.Renviron` file, you can use the helper function:

```r
usethis::edit_r_environ()
```

This will save you trying to find the file each time you want to edit it 😊.

Add the following lines to your `.Renviron`:

```
DATABRICKS_HOST=<var-databricks-url>
DATABRICKS_TOKEN=<var-personal-access-token>
DATABRICKS_CLUSTER_ID=<var-cluster-id>
DATABRICKS_VENV="databricks"
```

and replace each `<var->` element with the following information:

* for DATABRICKS_HOST add the base URL of your Databricks instance, beginning with `https://` and perhaps ending with `azuredatabricks.net`
* for DATABRICKS_TOKEN, go to your Databricks web instance, find your user settings, and in the 'Developer' section under 'Access tokens' click the 'Manage' button, then 'Generate new token'.
* for DATABRICKS_CLUSTER_ID, go to your Databricks instance, click on 'Compute' in the left-hand side menu, then click on the name of the cluster you are to use. The cluster ID will then be in the page URL after 'compute/clusters', or you can click on the three-dot menu and then 'View JSON'.

The DATABRICKS_VENV variable will be the name of your local Python virtual
  environment that will store the necessary Python libraries.
  The name can be anything you want but it's best to leave it as "databricks".

Once you have added these variables to your `.Renviron`, save it and restart
  your R session.


## Setup: {reticulate} and virtual environments

First, find out which version of Python your Databricks instance uses.
This can be done in a notebook with:

```python
%python
import sys
print(sys.version)
```

Here we will assume it is version 3.12.

Use the {reticulate} package to make the right Python version available:

```r
library(reticulate)
reticulate::install_python("3.12") # to match Databricks version
```

Use {reticulate} to create a custom Python virtual environment and install
  PySpark.
  (You can check what version of PySpark is installed by watching the output).

NB The `force=TRUE` parameter means that any existing virtual environment called
  "databricks" (or whatever your DATABRICKS_VENV envvar is) will be replaced.

```r
reticulate::virtualenv_create(
  envname = Sys.getenv("DATABRICKS_VENV"),
  python = "3.12", # match this to the version of Python installed above
  packages = "pyspark",
  force = TRUE
)
```

Use {pysparklyr} to install the databricks libraries.
Currently we use the same virtual environment as the one we just created, above.
This may not be strictly necessary, but it does avoid reinstalling various
  dependencies that were already installed along with PySpark.

```r
pysparklyr::install_databricks(
  version = "15.4", # match the version of Databricks used in your instance
  envname = Sys.getenv("DATABRICKS_VENV"),
  new_env = FALSE
)
```

## Problems

Please use GitHub to post an issue if you experience problems setting up or
  using the package.

## Further notes and links

* The development version of {pysparklyr} is [currently required on Windows](https://github.com/mlverse/pysparklyr/issues/125), in order to avoid an error when [trying to install RPy2](https://rpy2.github.io/doc/v3.5.x/html/overview.html#installation).
* [Posit/RStudio documentation](https://posit.co/blog/databricks-clusters-in-rstudio-with-sparklyr/)
* [Posit Spark/Databricks Connect documentation](https://spark.posit.co/deployment/databricks-connect.html)
