# frozen_string_literal: true

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  @sidekiq_pid ||= spawn('bundle exec sidekiq -c 2 -C config/sidekiq.yml')

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  if defined?($redis)
    $redis.quit
    $redis = nil
    Rails.logger.info('Disconnected from Redis')
  end
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  unless $redis
    $redis = Redis.new(url: ENV['REDIS_URL'])
    Rails.logger.info('Connected to Redis')
  end

  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end

  Sidekiq.configure_server do |config|
    config.redis = { size: 6 }
  end
end
