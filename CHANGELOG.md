## Unreleased

## 1.7.0 (December 27th 2022)

IMPROVEMENTS:

* The `RubyTerraform::MultiIO` class now more closely implements the `IO`
  contract. The `#<<` method has been added and the existing methods now return
  the expected values.
* Preliminary support has been added for modelling Terraform plans in Ruby
  types. The new `RubyTerraform::Models` namespace contains classes and factory
  functions to parse and wrap a generated plan, retrieved using the `show`
  command. The plan representation is currently incomplete and these type
  classes should be considered alpha quality for the time being.

## 1.6.0 (June 30th 2022)

IMPROVEMENTS:

* Add support for exposing environment variables to Terraform via a second hash
  of invocation options in command class methods and on the command `#execute`
  method.

## 1.5.0 (May 31st 2022)

IMPROVEMENTS:

* Add support for `replace` and / or `replaces` options to be passed to `plan`
  and `apply` commands.

## 1.4.0 (Jan 30th 2022)

BUG FIXES:

* Add missing requires.

## 1.3.0 (Oct 12th 2021)

IMPROVEMENTS:

* Allow arbitrary parameters to be passed to RubyTerraform::Output::for.

## 1.2.0 (May 10th 2021)

IMPROVEMENTS:

* Upgraded to latest version of dependencies.

## 1.1.0 (May 8th 2021)

BUG FIXES:

* Fixed version number in published documentation.

## 1.0.0 (May 8th 2021)

BREAKING CHANGES:

* Removed `RemoteConfig` command since it has not been a part of Terraform since
  version 0.8.
* Removed `Clean` command since it is not a Terraform command and was included
  as a utility for `RakeTerraform` which can handle this itself.
* Removed `:directory` option from `Show` command as it is not a part of the
  command. Use `:path` instead, which is a path to a state file or a plan.
* Renamed `:workspace` option to `:name` on workspace commands in line with how
  Terraform refers to it.
  
IMPROVEMENTS:

* Added support for most outstanding commands.
* Added support for all outstanding options.
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
