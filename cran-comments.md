## New submission (resubmission)
Enables binary package installations from RStudio's RSPM on Linux distributions
and provides automatic management of system requirements.

Fixes in this resubmission:

- Added a link to the used webservice to the description field of the
  DESCRIPTION file with angle brackets.
- Added \value to all .Rd files.
- Added examples to all .Rd files. Note that these examples cannot be executable
  because some systems (and CRAN systems in particular, i.e. Debian and Fedora)
  are not compatible with the service that this package provides.
- The package writes information messages for methods enable() and disable().
  This is intentional, because the primary usage would be to put enable() in the
  .Rprofile, so it's important to tell the user that the service is enabled.
  These messages can be easily suppressed with suppressMessages(), and this is
  indicated in the documentation.
- The package requires storing user-specific data in the proper place in the
  user directory. Now, this is done by calling tools::R_user_dir(), as specified
  in the CRAN policies.

## Test environments
- ubuntu:22.04, centos:stream8 on GitHub

## R CMD check results
0 errors | 0 warnings | 0 notes
