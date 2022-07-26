centos8_requirements <- c()

centos8_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system("dnf download --resolve", p(pkgs))
  system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
         "-r", user_dir(), "*")
}

centos8_install_sysreqs <- function(libs) {
  cat("Downloading and installing sysreqs...\n")
  centos8_install(paste0("*/", libs, collapse=" "))
}
