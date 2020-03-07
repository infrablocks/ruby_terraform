require 'rspec/core/rake_task'

require_relative 'rake/circleci'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :pipeline do
  namespace :env_vars do
    circle_ci_config = 'config/secrets/circle_ci/config.yaml'

    desc "Destroy all environment variables from the CircleCI pipeline"
    task :destroy do
      puts "Deleting all environment variables from pipeline..."
      CircleCI.new(circle_ci_config).delete_env_vars
      puts "Done."
    end

    desc "Provision all environment variables to the CircleCI pipeline"
    task :provision do
      puts "Creating all environment variables in pipeline..."
      env_vars = {
          'ENCRYPTION_PASSPHRASE':
              File.read('config/secrets/ci/encryption.passphrase').chomp
      }

      env_vars.each do |name, value|
        puts "Creating environment variable: #{name}"
        CircleCI.new(circle_ci_config).create_env_var(name, value)
      end

      puts "Done."
    end

    desc "Ensures all environment variables are configured on the CircleCI " +
        "pipeline"
    task :ensure => [:'destroy', :'provision']
  end
end

namespace :version do
  desc "Bump version for specified type (pre, major, minor patch)"
  task :bump, [:type] do |_, args|
    bump_version_for(args.type)
  end
end

desc "Release gem"
task :release do
  sh "gem release --tag --push"
end

def bump_version_for(version_type)
  sh "gem bump --version #{version_type} " +
      "&& bundle install " +
      "&& export LAST_MESSAGE=\"$(git log -1 --pretty=%B)\" " +
      "&& git commit -a --amend -m \"${LAST_MESSAGE} [ci skip]\""
end
