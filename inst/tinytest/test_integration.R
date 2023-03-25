os <- tryCatch(rspm:::os(), error=function(e) {
  tinytest::expect_match(e$message, "OS not supported")
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
expected <- "get(\"install_sysreqs\", asNamespace(\"rspm\"))()"
expect_true(grepl(expected, tracer, fixed=TRUE))

disable()
expect_false(inherits(utils::install.packages, "functionWithTrace"))
expect_false("RSPM" %in% names(getOption("repos")))
