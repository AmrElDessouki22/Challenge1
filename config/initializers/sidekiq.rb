require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url:  ENV['REDIS_URL']}
  config.on(:startup) do
    Sidekiq::Scheduler.load_schedule! 
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end