require "test_helper"

require "support/models"

describe CherryPick do
  it "has a version number" do
    value(CherryPick::VERSION).wont_be_nil
  end

  it "detects has_one associations" do
    value(node("city")).wont_be_nil
    value(node("city").relations).must_include("mayor")
  end

  it "detects belongs_to associations" do
    value(node("mayor")).wont_be_nil
    value(node("mayor").relations).must_include("beloved_city")
  end

  it "detects has_many associations" do
    value(node("city")).wont_be_nil
    value(node("city").relations).must_include("citizens")

    value(node("citizen")).wont_be_nil
    value(node("citizen").relations).must_include("home_city")
  end

  it "detects has_and_belongs_to_many associations" do
    value(node("city")).wont_be_nil
    value(node("city").relations).must_include("subways")

    value(node("subway")).wont_be_nil
    value(node("subway").relations).must_include("cities")
  end

  def node(name)
    CherryPick.directory[name]
  end
end
