if (!at_home())
  exit_file("not in a CI environment")

supported <- c("ubuntu", "centos", "rocky", "almalinux",
               "ol", "rhel", "amzn", "sles", "opensuse")

expect_silent(os <- rspm:::os())
expect_inherits(os, "list")
expect_true(os$id %in% supported)
exit_file(paste("code:", os$code))
