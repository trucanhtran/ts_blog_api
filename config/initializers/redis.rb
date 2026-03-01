# Redis initializer
# Global $redis instance available throughout the app
# Usage: $redis.get("key"), $redis.set("key", "value"), etc.

require "redis"

config = YAML.load(ERB.new(File.read(Rails.root.join("config/redis.yml"))).result)[Rails.env].symbolize_keys

$redis = Redis.new(config)

# Test connection on startup
begin
  $redis.ping
  Rails.logger.info "✓ Redis connected successfully"
rescue StandardError => e
  Rails.logger.warn "⚠ Redis connection warning: #{e.message}"
end
