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
  expr <- quote(rspm::install_sysreqs())
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

.onLoad <- function(libname, pkgname) {
  options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(
    getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))

  user_dir_init()
}
