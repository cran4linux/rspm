local(try({
  if (!requireNamespace("rspm", quietly=TRUE))
    renv::install("Enchufa2/rspm")
  rspm::enable()
}, silent=TRUE))
