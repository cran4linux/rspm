p <- function(...) paste(..., collapse=" ")
system <- function(...) base::system(p(...), intern=FALSE)
system_ <- function(...) suppressWarnings(base::system(p(...), intern=TRUE))

user_dir <- function(path="") {
  file.path(normalizePath("~"), ".local/share/R/rspm", path)
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
