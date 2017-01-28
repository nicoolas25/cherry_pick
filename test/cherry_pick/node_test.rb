require "test_helper"

describe CherryPick::Node do
  let(:instance) { CherryPick::Node.new(model, path, policy) }
  let(:policy) { CherryPick::Policy.new }
  let(:model) { 5 }
  let(:path) { CherryPick::Path.root }

  it "aggregates a model and a path" do
    value(instance.model).must_equal model
    value(instance.path).must_equal path
  end

  it "compares to another node using its model" do
    instance_2 = CherryPick::Node.new(model, "/different", policy)
    value(instance).must_be :eql?, instance_2
    value(instance.hash).must_equal instance_2.hash

    instance_3 = CherryPick::Node.new(4, path, policy)
    value(instance).wont_be :eql?, instance_3
    value(instance.hash).wont_equal instance_3.hash

    # Work within a Hash (and a Set)
    (hash = {instance => 1})[instance_2] = 2
    value(hash[instance]).must_equal 2
  end

  describe "#relations" do
    let(:model) { City.new(name: "Paris") }
    let(:path) { CherryPick::Path.root << "name" }

    it "returns the list of the model's associations" do
      value(instance.relations).must_equal %w(mayor citizens subways)
    end

    describe "policy forbids this depth" do
      let(:policy) { CherryPick::Policy.new(max_depth: 1) }

      it "returns an empty Array" do
        value(instance.relations).must_equal []
      end
    end
  end
end
