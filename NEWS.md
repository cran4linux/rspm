# rspm 0.4.0

- Implement root mode to improve Docker workflows (#20 addressing #17).
- Internal refactoring to improve extensibility (as part of #20).
- Remove libs' arch subfolder in Ubuntu to fix relative path issues (#19).

# rspm 0.3.1

- Fix version detection in CentOS (#18 addressing #16).
- Fix unpacking for new rpm versions (as part of #18).

# rspm 0.3.0

- Add support for CentOS/RHEL 9 and derivatives (#13 addressing #12).

# rspm 0.2.3

- Fix non-root unpacking for old rpm/dpkg versions (#11 addressing #9, #10).

# rspm 0.2.2

- Fix root permission requirement for yum-based systems (#9).
- Clean up empty user directory.

# rspm 0.2.1

- Fix .Rprofile enabling error (#8).
- Some fixes requested by CRAN.

# rspm 0.2.0

- Add support for CentOS 7, RHEL 7 and 8 (#1).
- Add support for several RHEL derivatives: Rocky Linux 8, AlmaLinux 8,
  Oracle Linux 7 and 8, Amazon Linux 2 (#2).
- Add support for openSUSE / SLES 15.3 (#3).
- Add support for `renv` projects via `rspm::renv_init()` (#5 closing #4).

# rspm 0.1.0

- Initial release, with support for CentOS 8 and Ubuntu 18.04, 20.04 and 22.04.
