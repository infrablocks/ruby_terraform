## 0.11.2 (May 1st, 2018)

IMPROVEMENTS:

* Add refresh command
* Add validate command

## 0.9.0 (September 3rd, 2017)

BACKWARDS INCOMPATIBILITIES / NOTES:

* Due to backwards incompatible changes in terraform 0.10, this release will
  only work with terraform >= 0.10.

IMPROVEMENTS:

* The init command now uses -from-module to specify the source module
* The apply command now supports -auto-approve in preparation for an upcoming
  terraform release that will set this flag to false by default.
