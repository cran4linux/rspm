os <- tryCatch(rspm:::os(), error=function(e) {
  exit_file(e$message)
})

# user agent
expect_true(grepl(getRversion(), getOption("HTTPUserAgent")))

# user dir
expect_true(dir.exists(rspm:::user_dir()))

# tracing and repo setting
untrace(utils::install.packages)
expect_false(inherits(utils::install.packages, "functionWithTrace"))

enable()
expect_true(inherits(utils::install.packages, "functionWithTrace"))
expect_true("RSPM" %in% names(getOption("repos")))
expect_true(grepl(rspm:::os()$code, getOption("repos")["RSPM"]))

tracer <- paste(body(utils::install.packages), collapse="")
expect_true(grepl("rspm::install_sysreqs()", tracer, fixed=TRUE))

disable()
expect_false(inherits(utils::install.packages, "functionWithTrace"))
expect_false("RSPM" %in% names(getOption("repos")))
