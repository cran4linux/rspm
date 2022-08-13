#' Initialize an \pkg{renv} Project
#'
#' Substitutes \code{renv::init()} to initialize a new \pkg{renv} project with
#' \pkg{rspm} enabled. This function sets the appropriate infrastructure to
#' activate the integration. Then, packages can be installed normally via
#' \code{install.packages} and \code{update.packages}.
#'
#' @param ... Arguments to be passed to \code{renv::init()}.
#'
#' @return The project directory, invisibly. This function is called for its
#' side effects.
#'
#' @details Note that, if \code{renv::install} or \code{renv::update} are called
#' directly, then \code{rspm::install_sysreqs()} needs to be called manually.
#'
#' @examples
#' \dontrun{
#' # initialize a new project (with an empty R library)
#' rspm::renv_init()
#'
#' # install 'units' and all its dependencies from the system repos
#' install.packages("units")
#'
#' # install a specific version and install dependencies manually
#' renv::install("units@0.8-0")
#' rspm::install_sysreqs()
#' }
#'
#' @export
renv_init <- function(...) {
  if (!requireNamespace("renv", quietly=TRUE))
    stop("please install 'renv' for this functionality", call.=FALSE)

  project <- renv::init(...)
  renv_install()
  renv_append(project)

  invisible(project)
}

renv_install <- function() {
  libpath <- renv::paths$library()
  if (!dir.exists(file.path(libpath, "rspm")))
    file.copy(system.file(package="rspm"), libpath, recursive=TRUE)
}

renv_append <- function(project = ".") {
  target <- file.path(project, "renv/activate.R")
  if (any(grepl("rspm::enable()", readLines(target))))
    return()
  source <- readLines(system.file("resources/activate.R", package="rspm"))
  source <- gsub("VERSION", utils::packageVersion("rspm"), source)
  cat("", source, "", file=target, sep="\n", append=TRUE)
}
