#' Manage System Requirements
#'
#' Detect, install and configure system requirements. This function is
#' automatically called when the package is enabled via \code{\link{enable}}.
#' It can also be called manually at any time to update the system requirements.
#'
#' @return \code{install_sysreqs}: No return value, called for side effects.
#'
#' @examples
#' \dontrun{
#' # install 'units' without enabling the integration
#' install.packages("units")
#' # then trigger the installation of system requirements manually
#' rspm::install_sysreqs()
#' }
#'
#' @name manager
#' @export
install_sysreqs <- function() {
  message("Inspecting installed packages...")

  # get missing libraries
  if (!length(libs <- unique(unlist(missing_sysreqs()))))
    return(invisible())

  # install sysreqs and update rpath
  os_install_sysreqs(libs)
  if (!root()) set_rpath()
}

#' @return \code{missing_sysreqs}: A list of missing libraries, for debugging.
#' @name manager
#' @export
missing_sysreqs <- function() {
  libs <- ldd()
  lib.loc <- attr(libs, "lib.loc")

  libs <- lapply(libs, function(x) grep("not found$", x, value=TRUE))
  libs <- lapply(libs, function(x) sapply(strsplit(x, " => "), "[", 1))

  attr(libs, "lib.loc") <- lib.loc
  libs
}

ldd <- function(lib.loc = NULL) {
  lib.loc <- user_lib(lib.loc)
  ldd <- check_requirements("ldd")

  libs <- list.files(lib.loc, "\\.so$", full.names=TRUE, recursive=TRUE)
  libs <- system_(ldd, p(libs), "2>&1")
  libs <- split(libs, findInterval(seq_along(libs), grep(":$", libs)))
  names(libs) <- gsub(paste0(lib.loc, "/|:"), "", sapply(libs, "[", 1))
  libs <- lapply(lapply(libs, "[", -1), trimws)

  attr(libs, "lib.loc") <- lib.loc
  libs
}

set_rpath <- function(lib.loc = NULL) {
  lib.loc <- user_lib(lib.loc)
  patchelf <- check_requirements("patchelf")
  message("Configuring sysreqs...")

  slibs <- list.files(user_dir("usr"), "\\.so", full.names=TRUE, recursive=TRUE)
  slibs <- slibs[!is.na(file.info(slibs)$size)]
  rlibs <- list.files(lib.loc, "\\.so$", full.names=TRUE, recursive=TRUE)
  alibs <- c(rlibs, slibs)
  alibs <- alibs[!alibs %in% sapply(getLoadedDLLs(), "[[", "path")]
  rpath <- paste(unique(dirname(slibs)), collapse=":")

  for (lib in alibs)
    system_(patchelf, "--set-rpath", rpath, lib, "2>&1")

  invisible()
}
