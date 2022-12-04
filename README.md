# rspm: RStudio Package Manager

<!-- badges: start -->
[![Build Status](https://github.com/Enchufa2/rspm/workflows/build/badge.svg)](https://github.com/Enchufa2/rspm/actions)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/rspm)](https://cran.r-project.org/package=rspm)
<!-- badges: end -->

## Key features

- Connects to [RStudio Public Package Manager](https://packagemanager.rstudio.com/)
  to provide **fast binary installations** of R packages on Linux.
- **Complete coverage** of CRAN and BioConductor packages. 
- **Full integration** with the system package manager to resolve, download and
  configure system requirements automagically without leaving your R console.
- **Fully user mode**, no root privileges required.
- Support for **CentOS / RHEL** 7, 8 and 9.
- Support for **RHEL derivatives**:
  Rocky Linux 8-9, AlmaLinux 8-9, Oracle Linux 7-9, Amazon Linux 2.
- Support for **openSUSE / SLES** 15.3 and 15.4.
- Support for **Ubuntu** 18.04, 20.04 and 22.04 (requires `apt-file`).

Both R packages and system dependencies **are installed into the user home**.
For lightning-fast system-based installations (which have other advantages,
such as multitenancy, reversibility and automatic updates, still without root
privileges), see the [bspm](https://enchufa2.github.io/bspm/) package and
projects such as [cran2copr](https://github.com/Enchufa2/cran2copr) for Fedora
or [r2u](https://github.com/eddelbuettel/r2u) for Ubuntu.

## Demo

Here we enable `rspm` and trigger a binary installation of the `units` package.
Then, we can see how the UDUNITS-2 dependency is detected, downloaded and
configured.

![](https://github.com/Enchufa2/rspm/blob/main/docs/assets/rspm_units.gif?raw=true)

## Installation and usage

You can install it directly from GitHub using the `remotes` package:

```r
remotes::install_github("Enchufa2/rspm")
```

### Basic usage

You just need to enable it once for your session, and then you can install or
update packages normally via `install.packages` or `update.packages`.

```r
rspm::enable()
install.packages("units")
```

Packages with system requirements, like the one above, will be scanned and
configured automatically. Typically, everything will just work without any
further action. But if something gets misconfigured for some reason, it is
possible to manually trigger a reconfiguration with the following command:

```r
rspm::install_sysreqs()
```

To enable it by default for all sessions, put the following into your `.Rprofile`:

```r
rspm::enable() # wrap it in suppressMessages() to suppress the initial message
```

### {renv} projects

To initialize an `renv` project with `rspm` support, just run the following:

```r
rspm::renv_init()
```

This command runs `renv::init()` for you and then installs the infrastructure
required for the integration with `install.packages` and `update.packages`.
Note that, if `renv::install` or `renv::update` are called directly, then
`rspm::install_sysreqs()` needs to be called manually.

## Technical details

Since _always_, Linux R users have been struggling with source installations and
manual management of build dependencies. Several projects over the years tried
to lessen this pain by building repositories of binaries that complement and
scale up the offer by various distributions. See e.g. the
[c2d4u.team/c2d4u4.0+](https://launchpad.net/~c2d4u.team/+archive/ubuntu/c2d4u4.0+)
PPA repo for Ubuntu or, more recently, the
[autoCRAN](https://build.opensuse.org/project/show/devel:languages:R:autoCRAN)
OBS repo for OpenSUSE, the 
[iucar/cran](https://copr.fedorainfracloud.org/coprs/iucar/cran/) Copr repo for
Fedora, the [ArchRPkgs](https://github.com/dvdesolve/ArchRPkgs) repo for Arch
and the [r2u](https://github.com/eddelbuettel/r2u) repo again for Ubuntu.
These are tightly integrated and can be fully managed without leaving the R
console thanks to the [bspm](https://enchufa2.github.io/bspm/) package.
See [this paper](https://arxiv.org/abs/2103.08069) for a detailed review.

On the other hand, RStudio recently took a complementary approach by building
binaries---for various distributions, R versions and architectures---and serving
them via their own CRAN mirror, also called the
[RStudio Public Package Manager (RSPM)](https://packagemanager.rstudio.com/).
In contrast to the previous solutions, this method allows the user to install
binary packages as _user packages_ under their home directory (virtually
anywhere), instead of as _system packages_. The main issue is that the user has
still to manage run-time system requirements themselves (i.e., shared libraries
required by some packages to work), so this method by itself produces
installations that are fundamentally broken.

To fill this gap, this package not only provides an easy setup of RSPM, but also
monitors and scans every installation for missing system requirements, and then
automatically downloads, installs and configures them, relieving the user of
this task. This is done following the same complementary philosophy:
**everything is installed as _user packages_ under the home directory**. More
specifically, this package uses the path `~/.local/share/R/rspm` for this.

The main technical issue here is that libraries are search for only in a few
pre-configured places that belong to the system (such as `/usr/lib`), and thus
we need a mechanism to feed our new user-hosted library paths to R packages,
hopefully without restarting R and managing environment variables. This is
achieved by **automatically updating the `RPATH`** of every `.so` binary in our
user R packages. This `RPATH` is an optional entry that lives in the header
of ELF executables and shared libraries, and it is used by the dynamic linker
as the primary search path if exists. Therefore, it is the perfect mechanism
for this task, because it can be applied dynamically as new installations are
made, and without requiring any special privilege.

## Support

If you find any bug or you'd like to request support for other distributions
(importantly, they must be supported by RStudio), please file issues at our
[GitHub issue tracker](https://github.com/Enchufa2/rspm/issues).
Note though that some quirks may be expected:

- _Some library is not found_. This means that the library version in your
  system is different from what RStudio had when the package was built. This is
  more likely to happen in derivatives (e.g. Amazon Linux) that drift away from
  their parent.
- _Some package is installed from source_. This means that RStudio has no
  binary version for that package.

There is nothing _we_ can do from `rspm` in either case, so please **do not**
file issues about them. Unfortunately, the best _you_ can do is to install the
development packages for the required library and force a source installation
(i.e. _business as usual_).

## Disclaimer

_RStudio_ is a registered trademark of [Posit](https://posit.co/).
This software provides access to a public repository maintained by RStudio and
provided to the open-source community for free, but has no association with it.
