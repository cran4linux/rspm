if (!at_home())
  exit_file("not in a CI environment")

# requirements
reqs <- rspm:::check_requirements()
expect_true(all(reqs != ""))

# installation and loading
expect_false(requireNamespace("units", quietly=TRUE))

enable()
install.packages("units")
expect_true(requireNamespace("units", quietly=TRUE))

# cleanup
disable()
remove.packages("units")
