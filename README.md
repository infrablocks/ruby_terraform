# RubyTerraform

A simple wrapper around the Terraform binary to allow execution from within
a Ruby program, RSpec test or Rakefile.

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

To require `RubyTerraform`:

```ruby
require 'ruby-terraform'
```

### Supported versions and commands

`RubyTerraform` supports all commands and options up to Terraform 0.15, except
`terraform console`, `terraform test` and `terraform version`.

### Getting started

There are a couple of ways to call Terraform using `RubyTerraform`.

Firstly, the `RubyTerraform` module includes class methods for each of the
supported Terraform commands. Each class method takes a parameter hash
containing options to pass to Terraform.

For example, to save the plan of changes for a Terraform configuration located
under `infra/network` to a file called `network.tfplan` whilst providing some
vars:

```ruby
RubyTerraform.plan(
  chdir: 'infra/network',
  out: 'network.tfplan',
  vars: {
    region: 'eu-central'
  },
  var_file: 'defaults.tfvars'
)
```

To apply the generated plan of changes:

```ruby
RubyTerraform.apply(
  chdir: 'infra/network',
  plan: 'network.tfplan',
  vars: {
    region: 'eu-central'
  },
  var_file: 'defaults.tfvars'
)
```

...and to destroy the resulting resources:

```ruby
RubyTerraform.destroy(
  chdir: 'infra/network',
  vars: {
    region: 'eu-central'
  },
  var_file: 'defaults.tfvars'
)
```

Each class method also accepts a second hash argument of invocation options to
use at command invocation time. Currently, the only supported option is
`:environment` which allows environment variables to be exposed to Terraform.

For example, to apply a configuration with trace level logging:

```ruby
RubyTerraform.apply(
  {
    chdir: 'infra/network',
    plan: 'network.tfplan',
    vars: {
      region: 'eu-central'
    },
    var_file: 'defaults.tfvars'
  },
  {
    environment: {
      'TF_LOG' => 'trace'
    }
  }
)
```

Additionally, `RubyTerraform` allows command instances to be constructed and
invoked separately. This is useful when you need to override global
configuration on a command by command basis or when you need to pass a command
around.

Using the command class approach, the equivalent plan invocation above can be
achieved using:

```ruby
command = RubyTerraform::Commands::Plan.new
command.execute(
  chdir: 'infra/network',
  out: 'network.tfplan',
  vars: {
    region: 'eu-central'
  },
  var_file: 'defaults.tfvars'
)
```

As with the class methods, the `#execute` method accepts a second hash argument
of invocation options allowing an environment to be specified.

See the [API docs](https://infrablocks.github.io/ruby_terraform/index.html) for
the
[`RubyTerraform` module](https://infrablocks.github.io/ruby_terraform/RubyTerraform.html)
or the
[`RubyTerraform::Commands` module](https://infrablocks.github.io/ruby_terraform/RubyTerraform/Commands.html)
more details on the supported commands.

### Parameters

The parameter hash passed to each command, whether via the class methods or the
`#execute` method, supports all the options available on the corresponding
Terraform command. There are a few different types of options depending on what
Terraform expects to receive:

* `Boolean` options, accepting `true` or `false`, such as `:input` or `:lock`;
* `String` options, accepting a single string value, such as `:state` or
  `:target`;
* `Array<String>` options, accepting an array of strings, such as `:var_files`
  or `:targets`; and
* `Hash<String,Object>` options, accepting a hash of key value pairs, where the
  value might be complex, such as `:vars` and `:backend_config`.

For all options that allow multiple values, both a singular and a plural option
key are supported. For example, to specify multiple var files during a plan:

```ruby
RubyTerraform.plan(
  chdir: 'infra/network',
  out: 'network.tfplan',
  var_file: 'defaults.tfvars',
  var_files: %w[environment.tfvars secrets.tfvars]
)
```

In this case, all three var files are passed to Terraform.

Some options have aliases. For example, the `:out` option can also be provided
as `:plan` for symmetry with other terraform commands. However, in such
situations only one of the aliases should be used in the provided parameters
hash.

See the [API docs](https://infrablocks.github.io/ruby_terraform/index.html) for
a more complete listing of available parameter options.

### Configuration

`RubyTerraform` uses sensible defaults for all configuration options. However,
there are a couple of ways to override the defaults when they are sufficient.

#### Binary

By default, `RubyTerraform` looks for the Terraform binary on the system path.
To globally configure a specific binary location:

```ruby
RubyTerraform.configure do |config|
  config.binary = 'vendor/terraform/bin/terraform'
end
```

To configure the Terraform binary on a command by command basis, for example for
the `Plan` command:

```ruby
command = RubyTerraform::Commands::Plan.new(
  binary: 'vendor/terraform/bin/terraform'
)
command.execute(
  # ...
)
```

#### Logging

By default, `RubyTerraform` 's own log statements are logged to `$stdout` with
level `info`.

To globally configure a custom logger:

```ruby
require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

RubyTerraform.configure do |config|
  config.logger = logger
end
```

`RubyTerraform` supports logging to multiple different outputs at once,
for example:

```ruby
require 'logger'

file_device = Logger::LogDevice.new('/foo/bar.log')
stdout_device = Logger::LogDevice.new(STDOUT)
multi_io = RubyTerraform::MultiIO.new(file_device, stdout_device)

logger = Logger.new(multi_io, level: :debug)

RubyTerraform.configure do |config|
  config.binary = '/binary/path/terraform'
  config.logger = logger
  config.stdout = multi_io
  config.stderr = multi_io
end
```

> Creating the Logger with a file this way (using `Logger::LogDevice`),
> guarantees that the buffer content will be saved/written, as it sets
> **implicit flushing**.

Configured in this way, any logging performed by `RubyTerraform` will log to
both `STDOUT` and to the specified file.

To configure the logger on a command by command basis, for example for the
`Show` command:

```ruby
require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::DEBUG

command = RubyTerraform::Commands::Show.new(
  logger: logger
)
command.execute(
  # ...
)
```

#### Standard streams

By default, `RubyTerraform` uses streams `$stdin`, `$stdout` and `$stderr`.

To configure custom output and error streams:

```ruby
log_file = File.open('path/to/some/ruby_terraform.log', 'a')

RubyTerraform.configure do |config|
  config.stdout = log_file
  config.stderr = log_file
end
```

In this way, both outputs will be redirected to `log_file`.

Similarly, a custom input stream can be configured:

```ruby
require 'stringio'

input = StringIO.new("user\ninput\n")

RubyTerraform.configure do |config|
  config.stdin = input
end
```

In this way, terraform can be driven by input from somewhere other than
interactive input from the terminal.

To configure the standard streams on a command by command basis, for example for
the `Init` command:

```ruby
require 'logger'

input = StringIO.new("user\ninput\n")
log_file = File.open('path/to/some/ruby_terraform.log', 'a')

command = RubyTerraform::Commands::Init.new(
  stdin: input,
  stdout: log_file,
  stderr: log_file
)
command.execute(
  # ...
)
```

## Documentation

* [API docs](https://infrablocks.github.io/ruby_terraform/index.html)

## Development

To install dependencies and run the build, run the pre-commit build:

```shell script
./go
```

This runs all unit tests and other checks including coverage and code linting /
formatting.

To run only the unit tests, including coverage:

```shell script
./go test:unit
```

To attempt to fix any code linting / formatting issues:

```shell script
./go library:fix
```

To check for code linting / formatting issues without fixing:

```shell script
./go library:check
```

You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

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
