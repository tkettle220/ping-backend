uri = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
Redis.current = Redis.new(:url => uri)
