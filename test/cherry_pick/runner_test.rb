require "test_helper"

describe CherryPick::Runner do
  let(:instance) { CherryPick::Runner.new(config_file_content) }
  let(:config_file_content) do
    <<~CONTENT
    source_db adapter: "sqlite3", database: "./test/fixtures/source.sqlite3"
    target_db adapter: "sqlite3", database: "./test/fixtures/target.sqlite3"
    fetch do
      get City.where(id: 1)
    end
    CONTENT
  end

  describe "#dsl" do
    it "returns the DSL file matching the given config_file_content" do
      dsl = instance.dsl
      value(dsl.source_db_config).must_equal({
        adapter: "sqlite3",
        database: "./test/fixtures/source.sqlite3",
      })
      value(dsl.target_db_config).must_equal({
        adapter: "sqlite3",
        database: "./test/fixtures/target.sqlite3",
      })
    end
  end

  describe "#run" do
    def setup
      City.create(id: 1, name: "Paris")
      Mayor.create(id: 1, beloved_city_id: 1)
      instance.run
    end

    it "copies City #1 from source to target database" do
      CherryPick.within_connection(instance.dsl.target_db_config) do
        value(City.first.name).must_equal "Paris"
      end
    end

    it "copies the relation between city and mayor from source to target database" do
      CherryPick.within_connection(instance.dsl.target_db_config) do
        value(City.first.mayor).wont_be_nil
      end
    end
  end
end
