# frozen_string_literal: true

module RubyTerraform
  module Options
    DEFINITIONS =
      [
        # complex repeatable options with space separator
        %w[-var].map do |o|
          definition(
            name: o, option_type: :standard, value_type: :complex,
            repeatable: true, separator: ' '
          )
        end,

        # complex repeatable options with default separator
        %w[-backend-config].map do |o|
          definition(
            name: o, option_type: :standard, value_type: :complex,
            repeatable: true,
            override_keys: { singular: false, plural: :backend_config }
          )
        end,

        # string repeatable options
        %w[-var-file -target -platform -plugin-dir -replace].map do |o|
          definition(
            name: o, option_type: :standard, value_type: :string,
            repeatable: true
          )
        end,

        # boolean options
        %w[
          -auto-approve
          -backend
          -get
          -get-plugins
          -input
          -list
          -lock
          -refresh
          -upgrade
          -verify-plugins
          -write
        ].map do |o|
          definition(name: o, option_type: :standard, value_type: :boolean)
        end,

        # flag options
        %w[
          -allow-missing
          -allow-missing-config
          -check
          -compact-warnings
          -destroy
          -detailed-exitcode
          -diff
          -draw-cycles
          -dry-run
          -force
          -force-copy
          -ignore-remote-version
          -json
          -no-color
          -raw
          -reconfigure
          -recursive
          -update
        ].map do |o|
          definition(name: o, option_type: :flag, value_type: :boolean)
        end,

        # string options
        %w[
          -backup
          -backup-out
          -from-module
          -fs-mirror
          -id
          -lock-timeout
          -lockfile
          -module-depth
          -net-mirror
          -parallelism
          -plan
          -provider
          -state
          -state-out
          -type
        ].map do |o|
          definition(name: o, option_type: :standard, value_type: :string)
        end,

        # string options with extra keys
        definition(
          name: '-config', option_type: :standard, value_type: :string,
          extra_keys: { singular: %i[directory] }
        ),
        definition(
          name: '-out', option_type: :standard, value_type: :string,
          extra_keys: { singular: %i[plan] }
        ),

        # global options
        definition(
          name: '-chdir', option_type: :standard, value_type: :string,
          placement: :after_command,
          extra_keys: { singular: %i[working_directory] }
        )
      ].flatten.freeze
  end
end
