require 'async'
require 'async/sequel/postgres/database'
require 'async/sequel/connection_pool/fibered'
require 'sequel'

module AsyncSequelDemo
  MODEL_PATH = File.expand_path('../models', __dir__)
  ENV_DEFAULT = :development

  def self.env
    (ENV['APP_ENV'] || ENV['RAILS_ENV'] || ENV_DEFAULT).to_sym
  end

  def self.adapter_options(async)
    if (async)
      {
        adapter: Async::Sequel::Postgres::Database,
        pool_class: AsyncSequelDemo::ConnectionPool
      }
    else
      {
        adapter: 'postgres'
      }
    end
  end

  def self.db(with_models: true, async: true)
    db_config = config.database

    Sequel.connect(
      **adapter_options(async),
      database: db_config.database,
      user: db_config.username,
      password: db_config.password,
      host: db_config.host,
      port: db_config.port,
      max_connections: db_config.max_connections
    ).tap do |db|
      db.extension(:pg_json)
      db.extension(:pg_array)

      import_models!(db) if (with_models)
    end
  end

  def self.import_models!(db)
    # Sequel::Model.db = db

    return if (defined?(@imported_models))

    Dir.glob(MODEL_PATH + '/*.rb').sort.each do |file|
      require file
    end

    @imported_models = true
  end

  def self.config
    AsyncSequelDemo::Config
  end
end

require_relative 'async_sequel_demo/connection_pool'
require_relative 'async_sequel_demo/config'
