## 0.66.0 (? ? 2021)

BREAKING CHANGES:

* Removed `RemoteConfig` command since it has not been a part of Terraform since
  version 0.8.
  
IMPROVEMENTS:

* Added support for most outstanding commands
* Added support for all outstanding options
* Added Terraform 0.15 support.

## 0.31.0 (September 25th, 2019)

IMPROVEMENTS

* Added support for `target` and / or `targets` options to be passed to `apply`,
  `plan`, `refresh` and `destroy` commands.
* Added support for `plan` option to `apply` command to be more clear when 
  applying a prebuilt plan.

## 0.30.0 (September 25th, 2019)

IMPROVEMENTS:

* Added configurable logger and standard streams.

## 0.12.0 (June 5th, 2018)

IMPROVEMENTS:

* Allowed `check_variables` option to be passed to `validate` command

BUG FIXES:

* Added missing `StringIO` dependency in `output` command 

## 0.11.2 (May 1st, 2018)

IMPROVEMENTS:

* Added refresh command
* Added validate command

## 0.9.0 (September 3rd, 2017)

BACKWARDS INCOMPATIBILITIES / NOTES:

* Due to backwards incompatible changes in terraform 0.10, this release will
  only work with terraform >= 0.10.

IMPROVEMENTS:

* The init command now uses -from-module to specify the source module
* The apply command now supports -auto-approve in preparation for an upcoming
  terraform release that will set this flag to false by default.
