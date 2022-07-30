if (!requireNamespace("renv", quietly=TRUE))
  exit_file("renv not available for testing")

# infrastructure
dir.create(temp <- tempfile())
old <- setwd(temp)
renv_init()

expect_true(dir.exists(file.path(renv::paths$library(), "rspm")))
infra <- readLines(file.path(renv::project(), "renv/activate.R"))
expect_true(any(grepl("rspm::enable()", infra)))

# cleanup
setwd(old)
unlink(temp, recursive=TRUE, force=TRUE)
