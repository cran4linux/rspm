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
  get(paste0(os()$name, "_install_sysreqs"), asNamespace("rspm"))(libs)
  set_rpath()
}

#' @name manager
#' @export
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

p <- function(...) paste(..., collapse=" ")
system <- function(...) base::system(p(...), intern=FALSE)
system_ <- function(...) suppressWarnings(base::system(p(...), intern=TRUE))

ldd_missing <- function(x) {
  ldd <- check_requirements("ldd")
  libs <- system_(ldd, p(x), "2>&1")
  libs <- grep("not found", libs, value=TRUE)
  libs <- sapply(strsplit(trimws(libs), " => "), "[", 1)
  libs
}

check_requirements <- function(cmd) {
  preqs <- get(paste0(os()$name, "_requirements"), asNamespace("rspm"))
  preqs <- Sys.which(preqs)
  if (length(x <- names(preqs)[preqs == ""]))
    stop("please, install the following required utilities: ", x, call.=FALSE)

  reqs <- c("ldd", "patchelf")
  reqs <- Sys.which(reqs)
  idx <- reqs == ""
  names(reqs)[idx] <- file.path(user_dir("usr/bin"), names(reqs)[idx])
  reqs <- Sys.which(names(reqs))

  if (length(missing <- basename(names(reqs))[reqs == ""])) {
    cat("Downloading and installing required utilities...\n")
    get(paste0(os()$name, "_install"), asNamespace("rspm"))(missing)
    reqs <- Sys.which(names(reqs))
  }

  names(reqs) <- basename(names(reqs))
  if (any(reqs == ""))
    stop("something went wrong, utilities not available", call.=FALSE)
  reqs <- c(preqs, reqs)

  if (missing(cmd)) reqs else reqs[cmd]
}
