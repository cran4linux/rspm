#' Enable/Disable RStudio Package Manager
#'
#' Functions to enable or disable the integration of \code{\link{install_sysreqs}}
#' into \code{\link{install.packages}}. When enabled, binary packages are
#' installed from RSPM if available, and system requirements are transparently
#' resolved and installed without root privileges.
#'
#' @details To enable \pkg{rspm} system-wide by default, include the following:
#'
#' \code{suppressMessages(rspm::enable())}
#'
#' into the \code{Rprofile.site} file. To enable it just for a particular user,
#' move that line to the user's \code{~/.Rprofile} instead.
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
  trace(utils::install.packages, exit=expr, print=FALSE)
  invisible()
}

#' @name integration
#' @export
disable <- function() {
  disable_repo()
  untrace(utils::install.packages)
  invisible()
}

#' @name integration
#' @export
enable_repo <- function() {
  opt$repos <- getOption("repos")
  options(repos = c(RSPM = sprintf(url, os()$code)))
}

#' @name integration
#' @export
disable_repo <- function() {
  if (!is.null(opt$repos))
    options(repos = opt$repos)
  opt$repos <- NULL
}

url <- "https://packagemanager.rstudio.com/all/__linux__/%s/latest"
opt <- new.env(parent=emptyenv())

.onLoad <- function(libname, pkgname) {
  options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(
    getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
  dir.create(user_dir(), showWarnings=FALSE, recursive=TRUE, mode="0755")
}

os <- function() {
  os <- utils::read.table("/etc/os-release", sep="=", col.names=c("var", "val"),
                          stringsAsFactors=FALSE)
  os <- stats::setNames(as.list(os$val), os$var)
  code <- switch(
    id <- os$ID,
    "ubuntu" = os$VERSION_CODENAME,
    "centos" = paste0(id, os$VERSION_ID),
    "rhel"   = paste0("centos", substr(os$VERSION_ID, 1, 1)),
    stop("OS not supported", call.=FALSE)
  )
  list(id = id, code = code)
}

user_dir <- function(path="") {
  file.path(normalizePath("~"), ".local/share/R/rspm", path)
}
