# rspm: RStudio Package Manager

## Key features

- Connects to [RStudio Public Package Manager](https://packagemanager.rstudio.com/)
  to provide **fast binary installations** of R packages on Linux distributions.
- **Complete coverage** of CRAN and BioConductor packages. 
- **Full integration** with the system package manager to resolve, download and
  configure system requirements automagically without leaving your R console.
- **Fully user mode**, no root privileges required.
- Support for **CentOS 8** and **Ubuntu** (requires `apt-file`).

Both R packages and system dependencies **are installed into the user home**.
For lightning-fast system-based installations (which have other advantages,
such as multitenancy, reversibility and automatic updates, still without root
privileges), see the [`bspm`](https://github.com/Enchufa2/bspm) package and
projects such as [cran2copr](https://github.com/Enchufa2/cran2copr) for Fedora
or [r2u](https://github.com/eddelbuettel/r2u) for Ubuntu.

## Demo

Here we enable `rspm` and trigger a binary installation of the `units` package.
Then, we can see how the UDUNITS-2 dependency is detected, downloaded and
configured.

![](https://github.com/Enchufa2/rspm/blob/main/docs/assets/rspm_units.gif?raw=true)

## Installation

You can install it directly from GitHub using the `remotes` package:

```r
remotes::install_github("Enchufa2/rspm")
```

To enable it by default, put the following into your `.Rprofile`:

```
rspm::enable() # wrap it in suppressMessages() to avoid the initial message
```

Then, run `install.packages` as usual, and `rspm` will take care of the rest.

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
console thanks to the [`bspm`](https://github.com/Enchufa2/bspm) package.

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

Currently, CentOS 8 and Ubuntu (tested on _jammy_) are supported. If you find
any bug or you'd like to request support for other distributions (importantly,
they must be supported by RStudio), please file issues at our
[GitHub issue tracker](https://github.com/Enchufa2/rspm/issues).

## Disclaimer

_RStudio_ is a registered trademark of [RStudio, PBC](https://www.rstudio.com/).
This software provides access to a public repository maintained by RStudio and
provided to the open-source community for free, but has no association with it.
