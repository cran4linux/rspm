tmp_user_dir <- tempdir()
Sys.setenv(RSPM_USER_DIR=tmp_user_dir)

if (requireNamespace("tinytest", quietly=TRUE)) {
  home <- identical(Sys.getenv("CI"), "true")
  tinytest::test_package("rspm", at_home=home)
}

unlink(tmp_user_dir, recursive=TRUE, force=TRUE)
