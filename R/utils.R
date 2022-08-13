p <- function(...) paste(..., collapse=" ")
system <- function(...) base::system(p(...), intern=FALSE)
system_ <- function(...) suppressWarnings(base::system(p(...), intern=TRUE))

user_dir <- function(path="") {
  tenv <- asNamespace("tools")
  if (exists("R_user_dir", tenv))
    R_user_dir <- get("R_user_dir", tenv)
  file.path(R_user_dir("rspm"), path)
}

user_lib <- function(lib.loc = NULL) {
  if (is.null(lib.loc))
    lib.loc <- .libPaths()[1]
  lib.loc
}

check_requirements <- function(cmd) {
  preqs <- get(paste0(os()$id, "_requirements"), asNamespace("rspm"))
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
    get(paste0(os()$id, "_install"), asNamespace("rspm"))(missing)
    reqs <- Sys.which(names(reqs))
  }

  names(reqs) <- basename(names(reqs))
  if (any(reqs == ""))
    stop("something went wrong, utilities not available", call.=FALSE)
  reqs <- c(preqs, reqs)

  if (missing(cmd)) reqs else reqs[cmd]
}
