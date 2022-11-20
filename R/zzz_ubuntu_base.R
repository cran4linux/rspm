ubuntu_requirements <- c("apt-file")

ubuntu_install <- function(pkgs) {
  system("apt-get", ubuntu_options(), "update")
  system("apt-get", ubuntu_options(), "-y -d install", p(pkgs))
  debs <- user_dir("var/cache/apt/archives/*.deb")
  ver <- strsplit(system_("dpkg --version"), " ")[[1]][7]
  if (package_version(ver) >= "1.21")
    ubuntu_install_modern(debs) else ubuntu_install_old(debs)
  unlink(Sys.glob(debs))
}

ubuntu_install_modern <- function(debs) {
  system("dpkg --unpack --force-not-root --force-script-chrootless",
         "--instdir", user_dir(), debs)
}

ubuntu_install_old <- function(debs) {
  for (file in Sys.glob(debs))
    system("dpkg-deb -x", file, user_dir())
}

ubuntu_install_sysreqs <- function(libs) {
  apt_file <- check_requirements("apt-file")

  # get package names
  patt <- gsub(".", "\\.", paste0("'(", paste(libs, collapse="|"), ")'"), fixed=TRUE)
  system(apt_file, ubuntu_options(), "update")
  pkgs <- system_(apt_file, ubuntu_options(), "-l search --regexp", patt)

  # download and unpack
  cat("Downloading and installing sysreqs...\n")
  ubuntu_install(pkgs)
}

ubuntu_options <- function() {
  lists <- file.path(user_dir("var"), "lib/apt/lists")
  cache <- file.path(user_dir("var"), "cache/apt/archives")
  dir.create(lists, showWarnings=FALSE, recursive=TRUE, mode="0755")
  dir.create(cache, showWarnings=FALSE, recursive=TRUE, mode="0755")
  paste0("-o dir::state::lists=", lists, " -o dir::cache=", dirname(cache),
         " -o Debug::NoLocking=1")
}
