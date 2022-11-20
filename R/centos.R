centos_requirements <- c()

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system(centos_cmd(), p(pkgs))
  ver <- strsplit(system_("rpm --version"), " ")[[1]][3]
  if (package_version(ver) >= "4.16")
    centos_install_modern()
  else if (package_version(ver) >= "4.12")
    centos_install_old()
  else centos_install_old_old()
}

centos_install_modern <- function() {
  system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
         "-r", user_dir(), "*.rpm")
}

centos_install_old <- function() {
  for (file in list.files(pattern=".rpm$"))
    system("cat", file, "| rpm2archive - | tar xfz - -C", user_dir())
}

centos_install_old_old <- function() {
  for (file in list.files(pattern=".rpm$"))
    system("rpm2cpio", file, "| (cd", user_dir(), "; cpio -dium --quiet)")
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
