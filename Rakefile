# frozen_string_literal: true

require 'rake_git'
require 'rake_git_crypt'
require 'rake_github'
require 'rake_gpg'
require 'rake_slack'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'securerandom'
require 'yard'

task default: %i[
  library:fix
  test:unit
]

RakeGitCrypt.define_standard_tasks(
  namespace: :git_crypt,

  provision_secrets_task_name: :'secrets:provision',
  destroy_secrets_task_name: :'secrets:destroy',

  install_commit_task_name: :'git:commit',
  uninstall_commit_task_name: :'git:commit',

  gpg_user_key_paths: %w[
    config/gpg
    config/secrets/ci/gpg.public
  ]
)

namespace :git do
  RakeGit.define_commit_task(
    argument_names: [:message]
  ) do |t, args|
    t.message = args.message
  end
end

namespace :encryption do
  namespace :directory do
    desc 'Ensure CI secrets directory exists.'
    task :ensure do
      FileUtils.mkdir_p('config/secrets/ci')
    end
  end

  namespace :passphrase do
    desc 'Generate encryption passphrase for CI GPG key'
    task generate: ['directory:ensure'] do
      File.write(
        'config/secrets/ci/encryption.passphrase',
        SecureRandom.base64(36)
      )
    end
  end
end

namespace :keys do
  namespace :gpg do
    RakeGPG.define_generate_key_task(
      output_directory: 'config/secrets/ci',
      name_prefix: 'gpg',
      owner_name: 'InfraBlocks Maintainers',
      owner_email: 'maintainers@infrablocks.io',
      owner_comment: 'ruby_terraform CI Key'
    )
  end
end

namespace :secrets do
  namespace :directory do
    desc 'Ensure secrets directory exists and is set up correctly'
    task :ensure do
      FileUtils.mkdir_p('config/secrets')
      unless File.exist?('config/secrets/.unlocked')
        File.write('config/secrets/.unlocked', 'true')
      end
    end
  end

  desc 'Generate all generatable secrets.'
  task generate: %w[
    encryption:passphrase:generate
    keys:gpg:generate
  ]

  desc 'Provision all secrets.'
  task provision: [:generate]

  desc 'Delete all secrets.'
  task :destroy do
    rm_rf 'config/secrets'
  end

  desc 'Rotate all secrets.'
  task rotate: [:'git_crypt:reinstall']
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = %w[--embed-mixins --output-dir docs]
end

namespace :library do
  desc 'Run all checks of the library'
  task check: [:rubocop]

  desc 'Attempt to automatically fix issues with the library'
  task fix: [:'rubocop:autocorrect_all']

  desc 'Build the library'
  task :build do
    sh 'gem build ruby_terraform.gemspec'
  end
end

namespace :documentation do
  desc 'Generate documentation'
  task generate: [:yard]

  desc 'Commit documentation'
  task :commit, [:skip] do |_, args|
    args.with_defaults(skip: 'true')

    skip_ci = args.skip == 'true'

    sh('git', 'commit',
       '-a',
       '-m', "Generate latest documentation#{' [ci skip]' if skip_ci}")
  end

  desc 'Update documentation'
  task update: %i[generate commit]
end

namespace :test do
  RSpec::Core::RakeTask.new(:unit)
end

RakeGithub.define_repository_tasks( # rubocop:disable Metrics/BlockLength
  namespace: :github,
  repository: 'infrablocks/ruby_terraform'
) do |t|
  # Operator's ambient auth. Resolve once and fail fast: a missing,
  # unauthenticated, or absent gh yields an empty string, which would
  # otherwise surface later as an opaque Octokit 401. An empty or
  # whitespace-only GITHUB_TOKEN is treated as absent so an authenticated
  # operator falls through to `gh auth token` rather than hitting the raise.
  github_token = ENV['GITHUB_TOKEN'].to_s.strip
  if github_token.empty?
    github_token = begin
      `gh auth token`
    rescue Errno::ENOENT
      ''
    end.strip
  end
  if github_token.empty?
    raise 'No GitHub token available: set GITHUB_TOKEN or run `gh auth login`'
  end

  t.access_token = github_token

  # Actions store only: dependabot runs never reach the passphrase — the
  # only pr.yaml job that unlocks git-crypt (prerelease) is guarded to
  # same-repo human PRs. Guard against a locked clone: without
  # it, File.read returns git-crypt ciphertext and github:secrets:ensure
  # silently uploads garbage that only surfaces much later as an opaque
  # GPG unlock failure in the release job.
  passphrase_path = 'config/secrets/ci/encryption.passphrase'
  unless File.exist?(passphrase_path)
    raise "Passphrase file not found: #{passphrase_path} — expected a " \
          'git-crypt-unlocked clone with the CI secrets present'
  end
  passphrase = File.binread(passphrase_path)
  if passphrase.start_with?("\x00GITCRYPT")
    raise 'encryption.passphrase is git-crypt ciphertext — unlock the ' \
          'clone before provisioning'
  end
  t.secrets = [
    { name: 'ENCRYPTION_PASSPHRASE', value: passphrase.chomp }
  ]
  t.environments = [
    { name: 'release',
      reviewers: [{ team: 'maintainers' }] }
  ]
end

namespace :slack do
  RakeSlack.define_notification_tasks do |t|
    t.bot_token = ENV.fetch('SLACK_BOT_TOKEN', nil)
    t.routing_rules = [
      { when: { type: 'on_hold' },
        channel: 'C038EDCRSQJ', format: :on_hold },  # release
      { when: { actor: 'dependabot[bot]', outcome: 'success' },
        channel: 'C03N711HVDG', format: :success },  # builds-dependabot
      { when: { actor: 'dependabot[bot]' },
        channel: 'C03N711HVDG', format: :failure },  # builds-dependabot
      { when: { outcome: 'success' },
        channel: 'C023XUE76GH', format: :success },  # builds
      # Failures go to builds, not team-dev (org default), to keep noise
      # out of a popular channel while this pipeline beds in.
      { when: {},
        channel: 'C023XUE76GH', format: :failure } # builds
    ]
  end
end

namespace :repository do
  desc 'Set the git author for CI'
  task :set_ci_author do
    sh 'git config --global user.name "InfraBlocks CI"'
    sh 'git config --global user.email "ci@infrablocks.io"'
  end
end

namespace :pipeline do
  desc 'Prepare GitHub Actions pipeline'
  task prepare: %i[
    github:secrets:ensure
    github:environments:ensure
  ]
end

namespace :version do
  desc 'Bump version for specified type (pre, major, minor, patch)'
  task :bump, [:type] do |_, args|
    bump_version_for(args.type)
  end
end

desc 'Release gem'
task :release do
  sh 'gem release --tag --push'
end

namespace :prerelease do
  desc 'Build and push a namespaced pre-release to RubyGems ' \
       '(PR CI only; no bump, no tag, no commit, no push)'
  task :publish, %i[pr_number run_number run_attempt] do |_, args|
    %i[pr_number run_number run_attempt].each do |name|
      raise "Missing task argument: #{name}" if args[name].to_s.empty?
    end

    version_file = 'lib/ruby_terraform/version.rb'
    version_pattern = /(VERSION\s*=\s*')([^']+)(')/
    source = File.read(version_file)
    base = source[version_pattern, 2]
    raise "Could not read VERSION from #{version_file}" unless base

    version = "#{base}.pr#{args.pr_number}" \
              ".#{args.run_number}.#{args.run_attempt}"
    gem_file = "ruby-terraform-#{version}.gem"
    begin
      File.write(version_file,
                 source.sub(version_pattern, "\\1#{version}\\3"))
      # Build + push directly: `gem release` aborts on the (deliberately)
      # uncommitted version rewrite. PR CI must not tag, commit, or push
      # (contrast the `release` task).
      sh 'gem build ruby_terraform.gemspec'
      sh "gem push #{gem_file}"
    ensure
      File.write(version_file, source)
      rm_f gem_file
    end
  end
end

def bump_version_for(version_type)
  sh "gem bump --version #{version_type} " \
     '&& bundle install ' \
     '&& export LAST_MESSAGE="$(git log -1 --pretty=%B)" ' \
     '&& git commit -a --amend -m "${LAST_MESSAGE} [ci skip]"'
end
