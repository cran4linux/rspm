centos_requirements <- c()

centos_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system(centos_cmd(), p(pkgs))
  uid <- as.integer(system_("id -u"))
  if (uid != 0L) centos_install_nonroot() else centos_install_root()
}

centos_install_nonroot <- function() {
  rpm_list <- list.files(pattern = ".rpm")
  check_centos_nonroot_reqs()
  for (rpm in rpm_list) {
    system("rpm2cpio", rpm, "| cpio", "--directory", user_dir(), "-id")
  }
}

check_centos_nonroot_reqs <- function() {
  reqs <- c("rpm2cpio", "cpio")
  reqs <- Sys.which(reqs)
  idx <- reqs == ""
  if (length(missing <- names(reqs)[idx])) {
    stop("Non-root requires 'rpm2cpio' and 'cpio' tools to unpack and copy ",
      "RPM packages into home directory without admin (sudo) rights.",
      "Quit current R session. Then install missing in shell with \n",
      p("`sudo dnf install", paste0(missing, "`.")), "\n",
      "Restart R and run `rspm::enable()` again to proceed.",
      call. = FALSE
    )
  }
}

centos_install_root <- function() {
  system(
    "rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
    "-r", user_dir(), "*"
  )
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