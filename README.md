# RubyTerraform

A simple wrapper around the Terraform binary to allow execution from within
a Ruby program or Rakefile.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_terraform'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_terraform


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
* `RubyTerraform::Commands::Apply`: executes `terraform apply`
* `RubyTerraform::Commands::Destroy`: executes `terraform destroy`
* `RubyTerraform::Commands::Output`: executes `terraform output`
* `RubyTerraform::Commands::RemoteConfig`: executes `terraform remote config`

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
RubyTerraform.init(source: 'some/module/path', path: 'infra/module')
RubyTerraform::Commands::Init.new.execute
RubyTerraform::Commands::Init.new.execute(
    source: 'some/module/path', 
    path: 'infra/module')
```

The init command supports the following options passed as keyword arguments:
* `source`: the source module to use to initialise; required if `path` is 
  specified
* `path`: the path to initialise.
* `backend`: `true`/`false`, whether or not to configure the backend.
* `get`: `true`/`false`, whether or not to get dependency modules.
* `backend_config`: a map of backend specific configuration parameters.
* `no_color`: whether or not the output from the command should be in color;
  defaults to `false`.


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
* `var_file`: a file holding list of variables with their values (in terraform format) to be passed to terraform
* `state`: the path to the state file in which to store state; defaults to
  terraform.tfstate in the working directory or the remote state if configured.
* `backup`: the path to the backup file in which to store the state backup.
* `no_backup`: when `true`, no backup file will be written; defaults to `false`.
* `no_color`: whether or not the output from the command should be in color;
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
* `var_file`: a file holding list of variables with their values (in terraform format) to be passed to terraform
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


### RubyTerraform::Commands::RemoteConfig

The remote config command configures storage of state using a remote backend. It
can be called in the following ways:

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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, 
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at 
https://github.com/tobyclemson/ruby_terraform. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the 
[MIT License](http://opensource.org/licenses/MIT).
