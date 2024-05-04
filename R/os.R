os_requirements <- function() {
  get(paste0(os()$id, "_requirements"))()
}

os_install <- function(pkgs) {
  get(paste0(os()$id, "_install"))(pkgs)
}

os_install_sysreqs <- function(libs) {
  get(paste0(os()$id, "_install_sysreqs"))(libs)
}

os <- function() {
  if (!file.exists("/etc/os-release"))
    stop("OS not supported", call.=FALSE)
  os <- utils::read.table("/etc/os-release", sep="=", col.names=c("var", "val"),
                          stringsAsFactors=FALSE)
  os <- stats::setNames(as.list(os$val), os$var)
  code <- switch(
    id <- strsplit(os$ID, "-")[[1]][1],
    "debian" = , "ubuntu" = os$VERSION_CODENAME,
    "centos" = , "rocky"  = , "almalinux" = , "ol" = , "rhel" =
      paste0(if ((ver <- safe_version(os$VERSION_ID)$major) < 9)
        "centos" else "rhel", ver),
    "amzn"   = if (os$VERSION_ID == "2") "centos7" else
      stop("OS not supported", call.=FALSE),
    "sles"   = , "opensuse" =
      paste0("opensuse", sub("\\.", "", os$VERSION_ID)),
    stop("OS not supported", call.=FALSE)
  )
  list(id = id, code = code)
}
