#' Enable/Disable RStudio Package Manager
#'
#' Functions to enable or disable RSPM repos as well as the integration of
#' \code{\link{install_sysreqs}} into \code{install.packages} and
#' \code{update.packages}. When enabled, binary packages are installed from
#' RSPM if available, and system requirements are transparently resolved and
#' installed without root privileges.
#'
#' @return No return value, called for side effects.
#'
#' @details To enable \pkg{rspm} permanently, include the following into your
#' \code{.Rprofile}:
#'
#' \code{suppressMessages(rspm::enable())}
#'
#' @seealso \code{\link{renv_init}} for \pkg{renv} projects.
#'
#' @examples
#' \dontrun{
#' # install 'units' and all its dependencies from the system repos
#' rspm::enable()
#' install.packages("units")
#'
#' # install packages again from CRAN
#' rspm::disable()
#' install.packages("errors")
#' }
#'
#' @name integration
#' @export
enable <- function() {
  check_requirements()
  enable_repo()
  expr <- quote(get("install_sysreqs", asNamespace("rspm"))())
  opt$utils <- !exists("install.packages")
  if (opt$utils) {
    trace(utils::install.packages, exit=expr, print=FALSE)
    trace(utils::update.packages, exit=expr, print=FALSE)
  } else {
    trace(install.packages, exit=expr, print=FALSE)
    trace(update.packages, exit=expr, print=FALSE)
  }
  invisible()
}

#' @name integration
#' @export
disable <- function() {
  disable_repo()
  if (isTRUE(opt$utils)) {
    untrace(utils::install.packages)
    untrace(utils::update.packages)
  } else {
    untrace(install.packages)
    untrace(update.packages)
  }
  invisible()
}

globalVariables(c("install.packages", "update.packages"))
url <- "https://packagemanager.rstudio.com/all/__linux__/%s/latest"
opt <- new.env(parent=emptyenv())

enable_repo <- function() {
  if (is.null(opt$repos))
    opt$repos <- getOption("repos")
  options(repos = c(RSPM = sprintf(url, os()$code)))
}

disable_repo <- function() {
  if (!is.null(opt$repos))
    options(repos = opt$repos)
  opt$repos <- NULL
}

os <- function() {
  os <- utils::read.table("/etc/os-release", sep="=", col.names=c("var", "val"),
                          stringsAsFactors=FALSE)
  os <- stats::setNames(as.list(os$val), os$var)
  code <- switch(
    id <- strsplit(os$ID, "-")[[1]][1],
    "ubuntu" = os$VERSION_CODENAME,
    "centos" = , "rocky"  = , "almalinux" = , "ol" = , "rhel" =
      paste0(if ((ver <- package_version(os$VERSION_ID)$major) < 9)
        "centos" else "rhel", ver),
    "amzn"   = if (os$VERSION_ID == "2") "centos7" else
      stop("OS not supported", call.=FALSE),
    "sles"   = , "opensuse" =
      paste0("opensuse", sub("\\.", "", os$VERSION_ID)),
    stop("OS not supported", call.=FALSE)
  )
  list(id = id, code = code)
}

.onLoad <- function(libname, pkgname) {
  options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(
    getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))

  if (is.na(path <- Sys.getenv("RSPM_USER_DIR", unset=NA)))
    path <- user_dir()
  opt$user_dir <- path
  dir.create(user_dir(), showWarnings=FALSE, recursive=TRUE, mode="0755")

  reg.finalizer(opt, onexit=TRUE, function(opt) {
    path <- opt$user_dir
    while (length(setdiff(dir(path, all.files=TRUE), c(".", ".."))) == 0) {
      unlink(path, recursive=TRUE, force=TRUE)
      path <- dirname(path)
    }
  })
}
