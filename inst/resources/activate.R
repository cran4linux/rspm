local({
  try_install_if_not_available <- function(pkg, source) {
    if (!requireNamespace(pkg, quietly=TRUE))
      try(renv::install(source), silent=TRUE)
  }

  try_install_if_not_available("rspm@VERSION")
  try_install_if_not_available("Enchufa2/rspm@VERSION")
  try_install_if_not_available("Enchufa2/rspm")

  try(rspm::enable(), silent=TRUE)
})
