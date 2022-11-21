rhel_requirements <- centos_requirements
amzn_requirements <- centos_requirements
rocky_requirements <- centos_requirements
almalinux_requirements <- centos_requirements
ol_requirements <- centos_requirements

rhel_install <- function(pkgs) centos_install(pkgs)
amzn_install <- function(pkgs) centos_install(pkgs)
rocky_install <- function(pkgs) centos_install(pkgs)
almalinux_install <- function(pkgs) centos_install(pkgs)
ol_install <- function(pkgs) centos_install(pkgs)

rhel_install_sysreqs <- function(libs) centos_install_sysreqs(libs)
amzn_install_sysreqs <- function(libs) centos_install_sysreqs(libs)
rocky_install_sysreqs <- function(libs) centos_install_sysreqs(libs)
almalinux_install_sysreqs <- function(libs) centos_install_sysreqs(libs)
ol_install_sysreqs <- function(libs) centos_install_sysreqs(libs)
