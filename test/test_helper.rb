$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
if ENV["COVERAGE"] == "on"
  require "simplecov"
  SimpleCov.start
end

require "cherry_pick"

require "minitest/spec"
require "minitest/autorun"

require "pry-byebug"

require "active_record"
ActiveRecord::Base.establish_connection({
  adapter: "sqlite3",
  database: ":memory:",
})
