centos_requirements <- c()

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system(centos_cmd(), p(pkgs))
  if (system("id -u") != 0) {
    rpm_list <- list.files(pattern = ".rpm")
    for (rpm in rpm_list) {
      system("rpm2cpio", rpm, "| cpio", "--directory", user_dir(), "-id")
    }
  } else {
    system(
      "rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
      "-r", user_dir(), "*"
    )
  }
}

centos_install_sysreqs <- function(libs) {
  cat("Downloading and installing sysreqs...\n")
  centos_install(paste0("*/", libs, collapse = " "))
}

centos_cmd <- function() {
  cmd <- "yumdownloader --resolve"
  if (Sys.which("dnf") != "") {
    cmd <- "dnf download --resolve"
  }
  cmd
}