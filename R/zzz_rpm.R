rpm_version <- function() {
  if (Sys.which("rpm") == "")
    stop("rpm not found", call.=FALSE)
  ver <- strsplit(system_("rpm --version"), " ")[[1]][3]
  package_version(ver)
}

rpm_requirements <- function() {
  ver <- rpm_version()
  # disable this altogether, it seems to fail in docker environments
  if (ver >= "1000.0") {
    rpm_requirements <- c()
  } else if (ver >= "4.12") {
    rpm_requirements <- c("cat", "tar")
  } else {
    rpm_requirements <- c("cpio")
  }
}

rpm_install <- function() {
  ver <- rpm_version()
  # disable this altogether, it seems to fail in docker environments
  if (ver >= "1000.0") {
    system("rpm -i --nodeps --noscripts --notriggers --nosignature --excludedocs",
           "--root", user_dir(), p(list.files(pattern=".rpm$", recursive=TRUE)))
  } else if (ver >= "4.12") {
    for (file in list.files(pattern=".rpm$", recursive=TRUE))
      system("cat", file, "| rpm2archive - | tar xfz - -C", user_dir())
  } else {
    for (file in list.files(pattern=".rpm$", recursive=TRUE))
      system("rpm2cpio", file, "| (cd", user_dir(), "; cpio -dium --quiet)")
  }
}
