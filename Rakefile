# add lib directory to load path
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pxfinder'

Rake.add_rakelib 'lib/tasks'

task default: :server

namespace :db do
  require 'sequel'

  desc 'Run migrations'
  task :migrate, [:version] do |_, args|
    DB = Sequel::Model.db
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.apply(DB, 'db/migrations', args[:version].to_i)
    else
      puts 'Migrating to latest'
      Sequel::Migrator.apply(DB, 'db/migrations')
    end
  end

  desc 'Drop all tables from database'
  task :drop do
    DB = Sequel::Model.db
    Sequel::Migrator.apply(DB, 'db/migrations', 0)
  end
end

task :console do
  trap('INT', 'IGNORE')
  dir, base = File.split(FileUtils::RUBY)
  cmd = if base.sub!(/\Aruby/, 'irb')
          File.join(dir, base)
        else
          "#{FileUtils::RUBY} -S irb"
        end
  sh "#{cmd} -I ./lib -r ./lib/pxfinder"
end

task :server do
  sh 'rackup'
end
