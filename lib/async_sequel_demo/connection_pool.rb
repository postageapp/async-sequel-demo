class AsyncSequelDemo::ConnectionPool < Async::Sequel::ConnectionPool::Fibered
  # Fixes Ruby 3 compatability issue with Sequel vs. Async-Sequel
  # https://github.com/socketry/async-sequel/issues/1
  def initialize(database, options)
    super(database, **options)
  end
end
