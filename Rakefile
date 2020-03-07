require 'sshkey'
require 'rspec/core/rake_task'

require_relative 'rake/circleci'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :circle_ci do
  circle_ci = CircleCI.new('config/secrets/circle_ci/config.yaml')

  namespace :env_vars do
    desc "Destroy all environment variables from the CircleCI pipeline"
    task :destroy do
      print "Deleting all environment variables from pipeline... "
      circle_ci.delete_env_vars
      puts "Done."
    end

    desc "Provision all environment variables to the CircleCI pipeline"
    task :provision do
      puts "Creating all environment variables in the pipeline... "
      env_vars = {
          'ENCRYPTION_PASSPHRASE':
              File.read('config/secrets/ci/encryption.passphrase').chomp
      }

      env_vars.each do |name, value|
        print "Creating environment variable: #{name}... "
        circle_ci.create_env_var(name, value)
      end

      puts "Done."
    end

    desc "Ensures all environment variables are configured on the CircleCI " +
        "pipeline"
    task :ensure => [:'destroy', :'provision']
  end

  namespace :ssh_key do
    desc "Destroy SSH key from the CircleCI pipeline"
    task :destroy do
      print "Destroying SSH key in the pipeline... "
      circle_ci.delete_ssh_keys
      puts "Done."
    end

    desc "Provision SSH key to the CircleCI pipeline"
    task :provision do
      print "Creating SSH key in the pipeline... "
      circle_ci.create_ssh_key(
          SSHKey.new(
              File.read('config/secrets/ci/ssh.private'),
              comment: 'github.com'))
      puts "Done."
    end

    desc "Ensures SSH key is configured on the CircleCI pipeline"
    task :ensure => [:'destroy', :'provision']
  end
end

namespace :pipeline do
  task :prepare => [
      :'circle_ci:env_vars:ensure',
      :'circle_ci:ssh_key:ensure',
  ]
end

namespace :version do
  desc "Bump version for specified type (pre, major, minor, patch)"
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
