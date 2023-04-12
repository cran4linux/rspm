centos_requirements <- function() rpm_requirements()

centos_install <- function(pkgs) {
  if (root()) return(centos_install_root(pkgs))

  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit({ setwd(old); unlink(temp, recursive=TRUE, force=TRUE) })

  cmd <- if (Sys.which("dnf") != "")
    "dnf download" else "yumdownloader"
  system(p(cmd, "--resolve"), p(pkgs))
  rpm_install()
}

centos_install_root <- function(pkgs) {
  cmd <- if (Sys.which("dnf") != "")
    "dnf" else "yum"
  system(cmd, "-y install", p(pkgs))
}

centos_install_sysreqs <- function(libs) {
  message("Downloading and installing sysreqs...")
  os_install(paste0("*/", libs, collapse=" "))
}
