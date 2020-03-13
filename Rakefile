require 'yaml'
require 'rake_circle_ci'
require 'rake_github'
require 'rake_ssh'
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec)

RakeSSH.define_key_tasks(
    namespace: :deploy_key,
    path: 'config/secrets/ci/',
    comment: 'maintainers@infrablocks.io'
)

RakeCircleCI.define_project_tasks(
    namespace: :circle_ci,
    project_slug: 'github/infrablocks/ruby_terraform'
) do |t|
  circle_ci_config =
      YAML.load_file('config/secrets/circle_ci/config.yaml')

  t.api_token = circle_ci_config["circle_ci_api_token"]
  t.environment_variables = {
      ENCRYPTION_PASSPHRASE:
          File.read('config/secrets/ci/encryption.passphrase')
              .chomp
  }
  t.ssh_keys = [
      {
          hostname: "github.com",
          private_key: File.read('config/secrets/ci/ssh.private')
      }
  ]
end

namespace :github do
  namespace :deploy_key do
    RakeGithub.define_deploy_key_tasks(
        repository: 'infrablocks/ruby_terraform',
        title: 'CircleCI'
    ) do |t|
      github_config =
          YAML.load_file('config/secrets/github/config.yaml')

      t.access_token = github_config["github_personal_access_token"]
      t.public_key = File.read('config/secrets/ci/ssh.public')
    end
  end
end

namespace :pipeline do
  task :prepare => [
      :'circle_ci:env_vars:ensure',
      :'circle_ci:ssh_keys:ensure',
      :'github:deploy_keys:ensure'
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
