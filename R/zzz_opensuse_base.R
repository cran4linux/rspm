opensuse_requirements <- function() rpm_requirements()

opensuse_install <- function(pkgs) {
  if (root()) return(opensuse_install_root(pkgs))

  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit({ setwd(old); unlink(temp, recursive=TRUE, force=TRUE) })

  system("zypper --pkg-cache-dir . install -dy", p(pkgs))
  rpm_install()
}

opensuse_install_root <- function(pkgs) {
  system("zypper install -y", p(pkgs))
}

opensuse_install_sysreqs <- function(libs) {
  # get package names
  pkgs <- system_("zypper search --provides", p(libs))
  pkgs <- grep("package$", pkgs, value=TRUE)
  pkgs <- trimws(sapply(strsplit(pkgs, "\\|"), "[", 2))

  # download and unpack
  os_install(pkgs)
}
