# RubyTerraform

A simple wrapper around the Terraform binary to allow execution from within
a Ruby program or Rakefile.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-terraform'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-terraform


## Usage

RubyTerraform needs to know where the terraform binary is located before it
can do anything. By default, RubyTerraform looks on the path however this can
be configured with:

```ruby
RubyTerraform.configure do |config|
  config.binary = 'vendor/terraform/bin/terraform'
end
```

In addition, each command that requires the terraform binary (all except
`clean`) takes a `binary` keyword argument at initialisation that overrides the
global configuration value.

Currently, there is partial support for the following commands:
* `RubyTerraform::Commands::Clean`: clean up all locally held terraform state
  and modules.
* `RubyTerraform::Commands::Init`: executes `terraform init`
* `RubyTerraform::Commands::Get`: executes `terraform get`
* `RubyTerraform::Commands::Plan`: executes `terraform plan`
* `RubyTerraform::Commands::Apply`: executes `terraform apply`
* `RubyTerraform::Commands::Show`: executes `terraform show`
* `RubyTerraform::Commands::Destroy`: executes `terraform destroy`
* `RubyTerraform::Commands::Output`: executes `terraform output`
* `RubyTerraform::Commands::Refresh`: executes `terraform refresh`
* `RubyTerraform::Commands::RemoteConfig`: executes `terraform remote config`
* `RubyTerraform::Commands::Validate`: executes `terraform validate`
* `RubyTerraform::Commands::Workspace`: executes `terraform workspace`

### RubyTerraform::Commands::Clean

The clean command can be called in the following ways:

```ruby
RubyTerraform.clean
RubyTerraform.clean(directory: 'infra/.terraform')
RubyTerraform::Commands::Clean.new(directory: 'infra/.terraform').execute
RubyTerraform::Commands::Clean.new.execute(directory: 'infra/.terraform')
```

When called, it removes the contents of the .terraform directory in the
working directory by default. If another directory is specified, it instead
removes the specified directory.


### RubyTerraform::Commands::Init

The init command will initialise a terraform environment. It can be called in
the following ways:

```ruby
RubyTerraform.init
RubyTerraform.init(from_module: 'some/module/path', path: 'infra/module')
RubyTerraform::Commands::Init.new.execute
RubyTerraform::Commands::Init.new.execute(
    from_module: 'some/module/path',
    path: 'infra/module')
```

The init command supports the following options passed as keyword arguments:
* `from_module`: the source module to use to initialise; required if `path` is
  specified
* `path`: the path to initialise.
* `backend`: `true`/`false`, whether or not to configure the backend.
* `get`: `true`/`false`, whether or not to get dependency modules.
* `backend_config`: a map of backend specific configuration parameters.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.
* `plugin_dir`: directory containing plugin binaries. Overrides all default;
  search paths for plugins and prevents the automatic installation of plugins.


### RubyTerraform::Commands::Get

The get command will fetch any modules referenced in the provided terraform
configuration directory. It can be called in the following ways:

```ruby
RubyTerraform.get(directory: 'infra/networking')
RubyTerraform::Commands::Get.new.execute(directory: 'infra/networking')
```

The get command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `update`: whether or not already downloaded modules should be updated;
  defaults to `false`.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


### RubyTerraform::Commands::Plan

The plan command will generate the execution plan in the provided
configuration directory. It can be called in the following ways:

```ruby
RubyTerraform.plan(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
RubyTerraform::Commands::Plan.new.execute(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
```

The plan command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `vars`: a map of vars to be passed in to the terraform configuration.
* `var_file`: the path to a terraform var file; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `var_files`: an array of paths to terraform var files; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `target`: the address of a resource to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `targets`: and array of resource addresses to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `state`: the path to the state file in which to store state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `plan`: the name of the file in which to save the generated plan.
* `input`: when `false`, will not ask for input for variables not directly set;
  defaults to `true`.
* `destroy`: when `true`, a plan will be generated to destroy all resources
  managed by the given configuration and state; defaults to `false`.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


### RubyTerraform::Commands::Apply

The apply command applies terraform configuration in the provided terraform
configuration directory. It can be called in the following ways:

```ruby
RubyTerraform.apply(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
RubyTerraform::Commands::Apply.new.execute(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
```

The apply command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `vars`: a map of vars to be passed in to the terraform configuration.
* `var_file`: the path to a terraform var file; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `var_files`: an array of paths to terraform var files; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `target`: the address of a resource to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `targets`: and array of resource addresses to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `state`: the path to the state file in which to store state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `backup`: the path to the backup file in which to store the state backup.
* `input`: when `false`, will not ask for input for variables not directly set;
  defaults to `true`.
* `no_backup`: when `true`, no backup file will be written; defaults to `false`.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.
* `auto_approve`: if `true`, the command applys without prompting the user to
  confirm the changes; defaults to `false`.


### RubyTerraform::Commands::Show

The show command produces human-readable output from a state file or a plan
file. It can be called in the following ways:

```ruby
RubyTerraform.show(
  path: 'infra/networking')
RubyTerraform::Commands::Show.new.execute(
  path: 'infra/networking')
```

The show command supports the following options passed as keyword arguments:
* `path`: the path to a state or plan file; required.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.
* `module_depth`: the depth of modules to show in the output; defaults to
  showing all modules.
* `json`: whether or not the output from the command should be in json format;
  defaults to `false`.

### RubyTerraform::Commands::Destroy

The destroy command destroys all resources defined in the terraform
configuration in the provided terraform configuration directory. It can be
called in the following ways:

```ruby
RubyTerraform.destroy(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
RubyTerraform::Commands::Destroy.new.execute(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
```

The destroy command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `vars`: a map of vars to be passed in to the terraform configuration.
* `var_file`: the path to a terraform var file; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `var_files`: an array of paths to terraform var files; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `target`: the address of a resource to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `targets`: and array of resource addresses to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `state`: the path to the state file containing the current state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `force`: if `true`, the command destroys without prompting the user to confirm
  the destruction; defaults to `false`.
* `backup`: the path to the backup file in which to store the state backup.
* `no_backup`: when `true`, no backup file will be written; defaults to `false`.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


### RubyTerraform::Commands::Output

The output command retrieves an output from a state file. It can be called in
the following ways:

```ruby
RubyTerraform.output(name: 'vpc_id')
RubyTerraform::Commands::Destroy.new.execute(name: 'vpc_id')
```

The output command supports the following options passed as keyword arguments:
* `name`: the name of the output to retrieve; required.
* `state`: the path to the state file containing the current state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.
* `module`: the name of a module to retrieve output from.


### RubyTerraform::Commands::Refresh

The refresh command will reconcile state with resources found in the target
environment. It can be called in the following ways:

```ruby
RubyTerraform.refresh(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
RubyTerraform::Commands::Refresh.new.execute(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
```

The refresh command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `vars`: a map of vars to be passed in to the terraform configuration.
* `var_file`: the path to a terraform var file; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `var_files`: an array of paths to terraform var files; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `target`: the address of a resource to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `targets`: and array of resource addresses to target; if both `target` and
  `targets` are provided, all targets will be passed to terraform.
* `state`: the path to the state file in which to store state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `input`: when `false`, will not ask for input for variables not directly set;
  defaults to `true`.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


### RubyTerraform::Commands::RemoteConfig

The remote config command configures storage of state using a remote backend. It
has been deprecated and since removed from terraform but is retained in this
library for backwards compatibility. It can be called in the following ways:

```ruby
RubyTerraform.remote_config(
  backend: 's3',
  backend_config: {
    bucket: 'example-state-bucket',
    key: 'infra/terraform.tfstate',
    region: 'eu-west-2'
  })
RubyTerraform::Commands::RemoteConfig.new.execute(
  backend: 's3',
  backend_config: {
    bucket: 'example-state-bucket',
    key: 'infra/terraform.tfstate',
    region: 'eu-west-2'
  })
```

The remote config command supports the following options passed as keyword
arguments:
* `backend`: the type of backend to use; required.
* `backend_config`: a map of backend specific configuration parameters;
  required.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


### RubyTerraform::Commands::Validate

The validate command validates terraform configuration in the provided terraform
configuration directory. It can be called in the following ways:

```ruby
RubyTerraform.validate(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
RubyTerraform::Commands::Validate.new.execute(
  directory: 'infra/networking',
  vars: {
    region: 'eu-central'
  })
```

The validate command supports the following options passed as keyword arguments:
* `directory`: the directory containing terraform configuration; required.
* `vars`: a map of vars to be passed in to the terraform configuration.
* `var_file`: the path to a terraform var file; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `var_files`: an array of paths to terraform var files; if both `var_file` and
  `var_files` are provided, all var files will be passed to terraform.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.
* `check_variables`: if `true`, the command checks whether all variables have
  been provided; defaults to `true`.
* `json`: whether or not the output from the command should be in json format;
  defaults to `false`.

### RubyTerraform::Commands::Workspace

The `workspace` command configures
[Terraform Workspaces](https://www.terraform.io/docs/state/workspaces.html#using-workspaces).
It can be used as follows:

```ruby
RubyTerraform.workspace(operation: 'list')
RubyTerraform.workspace(operation: 'new', workspace: 'staging')
RubyTerraform.workspace(operation: 'select', workspace: 'staging')
RubyTerraform.workspace(operation: 'list')
RubyTerraform.workspace(operation: 'select', workspace: 'default')
RubyTerraform.workspace(operation: 'delete', workspace: 'staging')
```

arguments:
* `directory`: the directory containing terraform configuration, the default is
  the current path.
* `operation`: `list`, `select`, `new` or `delete`. default `list`.
* `workspace`: Workspace name.


## Configuration

In addition to configuring the location of the terraform binary, RubyTerraform
offers configuration of logging and standard streams. By default standard
streams map to `$stdin`, `$stdout` and `$stderr` and all logging goes to
`$stdout`.

### Logging

By default, RubyTerraform logs to `$stdout` with level `info`.

To configure a custom logger:

``` ruby
require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

RubyTerraform.configure do |config|
  config.logger = logger
end
```

RubyTerraform supports logging to multiple different outputs at once,
for example:

``` ruby
require 'logger'

log_file = Logger::LogDevice.new('/foo/bar.log') # results in a file with sync true in the background
logger = Logger.new(RubyTerraform::MultiIO.new(STDOUT, log_file), level: :debug)

RubyTerraform.configure do |config|
  config.binary = '/binary/path/terraform'
  config.logger = logger
  config.stdout = logger
  config.stderr = logger
end
```
> Creating the Logger with a file this way (using `Logger::LogDevice`), guarantees that the buffer content will be saved/written, as it sets **implicit flushing**.

Configured in this way, any logging performed by RubyTerraform will log to both
`STDOUT` and the provided `log_file`.

### Standard Streams

By default, RubyTerraform uses streams `$stdin`, `$stdout` and `$stderr`.

To configure custom output and error streams:

``` ruby
log_file = File.open('path/to/some/ruby_terraform.log', 'a')

RubyTerraform.configure do |config|
  config.stdout = log_file
  config.stderr = log_file
end
```

In this way, both outputs will be redirected to `log_file`.

Similarly, a custom input stream can be configured:

``` ruby
require 'stringio'

input = StringIO.new("user\ninput\n")

RubyTerraform.configure do |config|
  config.stdin = input
end
```

In this way, terraform can be driven by input from somewhere other than
interactive input from the terminal.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```bash
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```bash
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/infrablocks/ruby_terraform. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
