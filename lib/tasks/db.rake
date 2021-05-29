require 'sequel'

require_relative '../async_sequel_demo'

namespace :db do
  desc 'Run migrations'
  task :migrate do
    Sequel.extension(:migration)

    Async do
      db = AsyncSequelDemo.db(with_models: false, async: false)

      Sequel::TimestampMigrator.run(db, 'db/migrations')

      Rake::Task['db:version'].execute
    end
  end

  desc 'Rollback last migration'
  task :rollback do
    Sequel.extension(:migration)

    Async do
      db = AsyncSequelDemo.db(with_models: false)

      version = db.tables.include?(:schema_migrations) ? db[:schema_migrations].first[:filename] : 0
      version -= 1 if version >= 1

      Sequel::TimestampMigrator.run(db, 'db/migrations', target: version.to_i)

      Rake::Task['db:version'].execute
    end
  end

  desc 'Get current schema version'
  task :version do
    Async do
      db = AsyncSequelDemo.db(with_models: false)

      version = db.tables.include?(:schema_migrations) && db[:schema_migrations].first[:filename]

      version, *rest = version.delete_suffix('.rb').split('_')

      puts "Current schema version: #{version} (#{rest.join(' ')})"
    end
  end
end
