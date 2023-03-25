rpm_version <- function() {
  if (Sys.which("rpm") == "")
    return(package_version("999.999"))
  ver <- strsplit(system_("rpm --version"), " ")[[1]][3]
  package_version(ver)
}

# disable this altogether, it seems to fail in docker environments
if (rpm_version() >= "1000.0") {
  centos_requirements <- c()
  centos_install_rpm <- function() {
    system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
           "--root", user_dir(), "*.rpm")
  }
} else if (rpm_version() >= "4.12") {
  centos_requirements <- c("cat", "tar")
  centos_install_rpm <- function() {
    for (file in list.files(pattern=".rpm$"))
      system("cat", file, "| rpm2archive - | tar xfz - -C", user_dir())
  }
} else {
  centos_requirements <- c("cpio")
  centos_install_rpm <- function() {
    for (file in list.files(pattern=".rpm$"))
      system("rpm2cpio", file, "| (cd", user_dir(), "; cpio -dium --quiet)")
  }
}

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system(centos_cmd(), p(pkgs))
  centos_install_rpm()
}

centos_install_sysreqs <- function(libs) {
  cat("Downloading and installing sysreqs...\n")
  centos_install(paste0("*/", libs, collapse=" "))
}

centos_cmd <- function() {
  cmd <- "yumdownloader --resolve"
  if (Sys.which("dnf") != "")
    cmd <- "dnf download --resolve"
  cmd
}
