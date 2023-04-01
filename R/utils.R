p <- function(...) paste(..., collapse=" ")
system <- function(...) base::system(p(...), intern=FALSE)
system_ <- function(...) suppressWarnings(base::system(p(...), intern=TRUE))
safe_version <- function(x) package_version(paste0(x, "-1"))
root <- function() Sys.info()["effective_user"] == "root"

user_dir_base <- NULL

user_dir <- function(path) {
  user_dir <- user_dir_base
  if (is.null(user_dir)) {
    tenv <- asNamespace("tools")
    if (exists("R_user_dir", tenv))
      R_user_dir <- get("R_user_dir", tenv)
    user_dir <- R_user_dir("rspm")
  }
  if (!missing(path))
    user_dir <- file.path(user_dir, path)
  user_dir
}

user_dir_init <- function() {
  if (!is.null(user_dir_base)) return()

  if (is.na(path <- Sys.getenv("RSPM_USER_DIR", unset=NA)))
    path <- user_dir()
  user_dir_base <<- path
  dir.create(user_dir(), showWarnings=FALSE, recursive=TRUE, mode="0755")

  reg.finalizer(opt, onexit=TRUE, function(opt) {
    path <- user_dir_base
    while (length(setdiff(dir(path, all.files=TRUE), c(".", ".."))) == 0) {
      unlink(path, recursive=TRUE, force=TRUE)
      path <- dirname(path)
    }
  })
}

user_lib <- function(lib.loc = NULL) {
  if (is.null(lib.loc))
    lib.loc <- .libPaths()[1]
  lib.loc
}

check_requirements <- function(cmd) {
  preqs <- Sys.which(os_requirements())
  if (length(x <- names(preqs)[preqs == ""]))
    stop("please, install the following required utilities: ", x, call.=FALSE)

  reqs <- c("ldd", if (!root()) "patchelf")
  reqs <- Sys.which(reqs)
  idx <- reqs == ""
  names(reqs)[idx] <- file.path(user_dir("usr/bin"), names(reqs)[idx])
  reqs <- Sys.which(names(reqs))

  if (length(missing <- basename(names(reqs))[reqs == ""])) {
    message("Downloading and installing required utilities...")
    os_install(missing)
    reqs <- Sys.which(names(reqs))
  }

  names(reqs) <- basename(names(reqs))
  if (any(reqs == ""))
    stop("something went wrong, utilities not available", call.=FALSE)
  reqs <- c(preqs, reqs)

  if (missing(cmd)) reqs else reqs[cmd]
}
