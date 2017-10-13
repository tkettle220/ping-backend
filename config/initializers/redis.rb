uri = ENV["REDIS_URL"] || "redis://redistogo:08ca119b81e44a5716104ec6311a3bd5@angelfish.redistogo.com:11848/"
Redis.current = Redis.new(:url => uri)
