require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :version do
  namespace :bump do
    desc "Bump version for prerelease"
    task :prerelease do
      bump_version_for('pre')
    end

    desc "Bump version for release"
    task :release do
      bump_version_for('minor')
    end
  end
end

namespace :publish do
  desc "Publish prerelease version"
  task :prerelease do
    Rake::Task['version:bump:prerelease'].invoke
    Rake::Task['release'].invoke
  end

  desc "Publish release version"
  task :release do
    Rake::Task['version:bump:release'].invoke
    Rake::Task['release'].invoke
  end
end

def bump_version_for(version_type)
  sh "gem bump --version #{version_type} " +
         "&& bundle install " +
         "&& git commit -a --amend --no-edit"
end
