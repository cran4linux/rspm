if (requireNamespace("tinytest", quietly=TRUE)) {
  home <- identical(Sys.getenv("CI"), "true")
  tinytest::test_package("rspm", at_home=home)
}
