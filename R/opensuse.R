opensuse_requirements <- c()

opensuse_install <- function(pkgs) {
  dir.create(temp <- tempfile("rspm_"))
  old <- setwd(temp)
  on.exit(setwd(old))
  system("zypper --pkg-cache-dir . install -dy", p(pkgs))
  system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
         "-r", user_dir(), p(list.files(recursive=TRUE)))
}

opensuse_install_sysreqs <- function(libs) {
  # get package names
  pkgs <- system_("zypper search --provides", p(libs))
  pkgs <- grep("package$", pkgs, value=TRUE)
  pkgs <- trimws(sapply(strsplit(pkgs, "\\|"), "[", 2))

  # download and unpack
  cat("Downloading and installing sysreqs...\n")
  opensuse_install(pkgs)
}
