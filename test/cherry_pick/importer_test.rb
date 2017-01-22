require "test_helper"

describe CherryPick::Importer do
  let(:instance) { CherryPick::Importer.new }

  describe "#run" do
    before { @result = instance.run(models) }

    let(:city) { City.new(id: 1, name: "Paris", created_at: Time.parse("2015-01-01 12:00:00 UTC")) }
    let(:mayor) { Mayor.new(id: 1, beloved_city_id: 1) }
    let(:models) { [ city, mayor ] }

    it "writes models to the database" do
      value(City.first).wont_be_nil
      value(Mayor.first).wont_be_nil
    end

    it "preserves the the created_at timestamp" do
      value(City.first.created_at).must_equal models.first.created_at
    end

    it "preserves belongs_to associations" do
      value(Mayor.first.beloved_city).must_equal City.first
    end

    it "preserves has_one associations" do
      value(City.first.mayor).must_equal Mayor.first
    end
  end
end
