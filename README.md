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

## Disclaimer

_RStudio_ is a registered trademark of [RStudio, PBC](https://www.rstudio.com/).
This software provides access to a public repository maintained by RStudio and
provided to the open-source community for free, but has no association with it.
