centos_requirements <- c()

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system("dnf download --resolve", p(pkgs))
  system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
         "-r", user_dir(), "*")
}

centos_install_sysreqs <- function(libs) {
  cat("Downloading and installing sysreqs...\n")
  centos_install(paste0("*/", libs, collapse=" "))
}
