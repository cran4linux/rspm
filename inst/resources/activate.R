local({
  if (!requireNamespace("rspm", quietly=TRUE))
    tryCatch({
      renv::install("rspm@VERSION")
    }, error = function(e) {
      renv::install("Enchufa2/rspm@VERSION")
    })
  try(rspm::enable(), silent=TRUE)
})
