centos_requirements <- c()

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system(centos_cmd(), p(pkgs))
  system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
         "-r", user_dir(), "*")
}

centos_install_sysreqs <- function(libs) {
  cat("Downloading and installing sysreqs...\n")
  centos_install(paste0("*/", libs, collapse=" "))
}

centos_cmd <- function() {
  cmd <- "yum install --downloadonly --downloaddir=."
  if (Sys.which("dnf") != "")
    cmd <- "dnf download --resolve"
  cmd
}
