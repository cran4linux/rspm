debian_requirements <- function() c("apt-file")

debian_install <- function(pkgs) {
  if (root()) return(debian_install_root(pkgs))

  system("apt-get", debian_options(), "update")
  system("apt-get", debian_options(), "-y -d install", p(pkgs))
  debs <- user_dir("var/cache/apt/archives/*.deb")
  on.exit(unlink(Sys.glob(debs)))
  dpkg_install(debs)
  fix_libs()
}

debian_install_root <- function(pkgs) {
  system("apt-get update")
  system("apt-get -y install", p(pkgs))
}

dpkg_install <- function(debs) {
  ver <- strsplit(system_("dpkg --version"), " ")[[1]][7]
  if (package_version(ver) >= "1000.0") { # disable, was 1.21
    system("dpkg --unpack --force-not-root --force-script-chrootless",
           "--root", user_dir(), debs)
  } else {
    for (file in Sys.glob(debs))
      system("dpkg-deb -x", file, user_dir())
  }
}

# move libs from x86_64-linux-gnu one level up (see #19)
fix_libs <- function() {
  libs <- Sys.glob(user_dir("usr/lib/*-linux-gnu/*"))
  file.copy(libs, user_dir("usr/lib/"), recursive=TRUE)
  unlink(libs, recursive=TRUE)
}

debian_install_sysreqs <- function(libs) {
  apt_file <- check_requirements("apt-file")

  # get package names
  patt <- gsub(".", "\\.", paste0("'(", paste(libs, collapse="|"), ")'"), fixed=TRUE)
  system(apt_file, debian_options(), "update")
  pkgs <- system_(apt_file, debian_options(), "-l search --regexp", patt)

  # download and unpack
  os_install(pkgs)
}

debian_options <- function() {
  if (root()) return(NULL)

  lists <- file.path(user_dir("var"), "lib/apt/lists")
  cache <- file.path(user_dir("var"), "cache/apt/archives")
  dir.create(lists, showWarnings=FALSE, recursive=TRUE, mode="0755")
  dir.create(cache, showWarnings=FALSE, recursive=TRUE, mode="0755")
  paste0("-o Dir::State::Lists=", lists, " -o Dir::Cache=", dirname(cache),
         " -o Debug::NoLocking=1")
}
