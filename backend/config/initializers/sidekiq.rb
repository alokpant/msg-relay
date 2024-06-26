# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
  Sidekiq::Scheduler.dynamic = true
  Sidekiq::Scheduler.enabled = true
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end
