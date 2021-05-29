require 'configature'

class AsyncSequelDemo::Config < Configature::Config
  self.config_dir = File.expand_path('../../config', __dir__)

  namespace :database do |db|
    db.env 'RAILS_ENV', default: 'development'

    db.adapter default: 'pg'
    db.database default: -> do
      case (env = AsyncSequelDemo.env)
      when :development
        'async_sequel_demo_dev'
      else
        'async_sequel_demo_%s' % env
      end
    end
    db.host default: 'localhost'
    db.port default: 5432, as: :integer
    db.username default: 'async_sequel_demo'
    db.password default: 'async_sequel_demo'
    db.max_connections default: 10
  end

  namespace :dns do |dns|
    dns.servers default: %w[ 8.8.8.8 ]
  end
end
