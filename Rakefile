require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

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
