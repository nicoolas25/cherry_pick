require "test_helper"

describe CherryPick::DSL do
  let(:instance) { CherryPick::DSL.new }

  it "responds to the DSL methods" do
    %w(source_db target_db fetch import).each do |method|
      value(instance).must_respond_to(method)
    end
  end

  describe "#source_db" do
    let(:config) do
      { adapter: "sqlite3", database: "./test/fixtures/source.sqlite3" }
    end

    it "accepts a database configuration as a Hash" do
      instance.source_db(config)
      value(instance.source_db_config).must_equal config
    end
  end

  describe "#target_db" do
    let(:config) do
      { adapter: "sqlite3", database: "./test/fixtures/target.sqlite3" }
    end

    it "accepts a database configuration as a Hash" do
      instance.target_db(config)
      value(instance.target_db_config).must_equal config
    end
  end

  describe "#fetch" do
    let(:block) { Proc.new { 1 + 1 } }

    it "accepts a block" do
      instance.fetch(&block)
      value(instance.fetch_block).must_equal block
    end
  end

  describe "#import" do
    let(:block) { Proc.new { 1 + 1 } }

    it "accepts a block" do
      instance.import(&block)
      value(instance.import_block).must_equal block
    end
  end
end
