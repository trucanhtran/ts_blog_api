# Redis initializer
# Global $redis instance available throughout the app
# Usage: $redis.get("key"), $redis.set("key", "value"), etc.

require "redis"

config_hash = YAML.load(ERB.new(File.read(Rails.root.join("config/redis.yml"))).result)[Rails.env]
redis_url = config_hash["url"]

# Create Redis client with URL and optional timeout
begin
  $redis = Redis.new(url: redis_url, timeout: config_hash["timeout"] || 5)

  # Test connection on startup
  $redis.ping
  Rails.logger.info "✓ Redis connected successfully"
rescue StandardError => e
  Rails.logger.warn "⚠ Redis connection warning: #{e.message}"
end
