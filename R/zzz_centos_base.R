centos_requirements <- function() rpm_requirements()

centos_install <- function(pkgs) {
  if (root()) return(centos_install_root(pkgs))

  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit({ setwd(old); unlink(temp, recursive=TRUE, force=TRUE) })

  cmd <- "yumdownloader --resolve"
  if (Sys.which("dnf") != "")
    cmd <- "dnf download --resolve"
  system(cmd, p(pkgs))
  rpm_install()
}

centos_install_root <- function(pkgs) {
  cmd <- "yum"
  if (Sys.which("dnf") != "")
    cmd <- "dnf"
  system(cmd, "-y install", p(pkgs))
}

centos_install_sysreqs <- function(libs) {
  message("Downloading and installing sysreqs...")
  os_install(paste0("*/", libs, collapse=" "))
}
