require 'sshkey'
require 'octokit'
require 'rspec/core/rake_task'

require_relative 'rake/circleci'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :ssh_key do
  desc "Generate a new SSH key for CI"
  task :generate do
    print "Generating a new SSH key... "
    key = SSHKey.generate(
        type: "RSA",
        bits: 4096,
        comment: "maintainers@infrablocks.io")
    File.write('config/secrets/ci/ssh.private', key.private_key)
    File.write('config/secrets/ci/ssh.public', key.public_key)
    puts "Done."
  end
end

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

    desc "Ensure all environment variables are configured on the CircleCI " +
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

    desc "Ensure SSH key is configured on the CircleCI pipeline"
    task :ensure => [:'destroy', :'provision']
  end
end

namespace :github do
  namespace :deploy_key do
    desc "Remove deploy key from the Github repository"
    task :destroy do
      print "Removing deploy key from the Github repository... "
      config = YAML.load_file('config/secrets/github/config.yaml')
      access_token = config["github_personal_access_token"]
      repo = config["github_repository"]
      client = Octokit::Client.new(access_token: access_token)

      deploy_keys = client.list_deploy_keys(repo)
      circle_ci_deploy_key = deploy_keys.find { |k| k[:title] == 'CircleCI' }
      if circle_ci_deploy_key
        client.remove_deploy_key(repo, circle_ci_deploy_key[:id])
      end
      puts "Done."
    end

    desc "Add deploy key to the Github repository"
    task :provision do
      print "Adding deploy key to the Github repository... "
      config = YAML.load_file('config/secrets/github/config.yaml')
      access_token = config["github_personal_access_token"]
      repo = config["github_repository"]
      client = Octokit::Client.new(access_token: access_token)

      ssh_key = SSHKey.new(
          File.read('config/secrets/ci/ssh.private'),
          comment: 'CircleCI')
      client.add_deploy_key(repo,
          ssh_key.comment,
          ssh_key.ssh_public_key,
          read_only: false)
      puts "Done."
    end

    desc "Ensure deploy key is configured on the Github repository"
    task :ensure => [:'destroy', :'provision']
  end
end

namespace :pipeline do
  task :prepare => [
      :'circle_ci:env_vars:ensure',
      :'circle_ci:ssh_key:ensure',
      :'github:deploy_key:ensure'
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
