#' Manage System Requirements
#'
#' Functions to install and configure system requirements.
#'
#' @seealso \code{\link{integration}}
#'
#' @name manager
#' @export
install_sysreqs <- function() {
  cat("Inspecting installed packages...\n")

  # get missing libraries
  libs <- list.files(.libPaths()[1], "\\.so$", full.names=TRUE, recursive=TRUE)
  if (!length(libs <- ldd_missing(libs)))
    return(invisible())

  # install sysreqs and update rpath
  get(paste0(os()$id, "_install_sysreqs"), asNamespace("rspm"))(libs)
  set_rpath()
}

ldd_missing <- function(x) {
  ldd <- check_requirements("ldd")
  libs <- system_(ldd, p(x), "2>&1")
  libs <- grep("not found", libs, value=TRUE)
  libs <- sapply(strsplit(trimws(libs), " => "), "[", 1)
  libs
}

set_rpath <- function() {
  patchelf <- check_requirements("patchelf")
  cat("Configuring sysreqs...\n")

  slibs <- list.files(user_dir("usr"), "\\.so", full.names=TRUE, recursive=TRUE)
  slibs <- slibs[!is.na(file.info(slibs)$size)]
  rlibs <- list.files(.libPaths()[1], "\\.so$", full.names=TRUE, recursive=TRUE)
  alibs <- c(rlibs, slibs)
  alibs <- alibs[!alibs %in% sapply(getLoadedDLLs(), "[[", "path")]
  rpath <- paste(unique(dirname(slibs)), collapse=":")

  for (lib in alibs)
    system_(patchelf, "--set-rpath", rpath, lib, "2>&1")

  invisible()
}
