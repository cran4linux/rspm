rhel_requirements <- c()

rhel_install <- function(pkgs) {
  centos_install(pkgs)
}

rhel_install_sysreqs <- function(libs) {
  centos_install_sysreqs(libs)
}
