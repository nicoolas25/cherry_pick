require "test_helper"

require "support/models"

describe CherryPick do
  it "has a version number" do
    value(CherryPick::VERSION).wont_be_nil
  end

  it "detects model associations" do
    value(CherryPick.directory["city"]).wont_be_nil
    value(CherryPick.directory["city"].related_models).must_include("mayors")
  end
end
