require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :version do
  desc "Bump version for specified type (pre, major, minor patch)"
  task :bump, [:type] do |_, args|
    bump_version_for(args.type)
  end
end

namespace :publish do
  desc "Publish prerelease version"
  task :prerelease do
    Rake::Task['version:bump'].invoke('pre')
    Rake::Task['release'].invoke
  end

  desc "Publish release version"
  task :release do
    Rake::Task['version:bump'].invoke('minor')
    Rake::Task['release'].invoke
  end
end

def bump_version_for(version_type)
  sh "gem bump --version #{version_type} " +
         "&& bundle install " +
         "&& git commit -a --amend --no-edit"
end
