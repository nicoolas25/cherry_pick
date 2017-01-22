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

#
# Prepare databases
#

require "fileutils"

%w(target source).each do |db_name|
  db_path = "./test/fixtures/#{db_name}.sqlite3"

  FileUtils.rm(db_path, force: true)

  ActiveRecord::Base.establish_connection({
    adapter: "sqlite3",
    database: db_path,
  })

  load "support/schema.rb"
end

#
# Setup database cleaner
#

require "database_cleaner"

DatabaseCleaner.strategy = :deletion

class Minitest::Spec
  before { DatabaseCleaner.start }
  after { DatabaseCleaner.clean }
end

require "support/models"
