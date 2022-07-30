#' Initialize an \pkg{renv} Project
#'
#' Substitutes \code{renv::init()} to initialize a new \pkg{renv} project with
#' \pkg{rspm} enabled. This function sets the appropriate infrastructure to
#' activate the integration. Then, packages can be installed normally via
#' \code{install.packages} and \code{update.packages}.
#'
#' @details Note that, if \code{renv::install} or \code{renv::update} are called
#' directly, then \code{rspm::install_sysreqs()} needs to be called manually.
#'
#' @export
renv_init <- function() {
  if (!requireNamespace("renv", quietly=TRUE))
    stop("please install 'renv' for this functionality", call.=FALSE)

  project <- renv::init()
  renv_install()
  renv_append(project)

  invisible(project)
}

renv_install <- function() {
  file.copy(system.file(package="rspm"), renv::paths$library(), recursive=TRUE)
}

renv_append <- function(project = ".") {
  source <- readLines(system.file("resources/activate.R", package="rspm"))
  source <- gsub("VERSION", utils::packageVersion("rspm"), source)
  target <- file.path(project, "renv/activate.R")
  cat("", source, "", file=target, sep="\n", append=TRUE)
}
