require "test_helper"

describe CherryPick::Policy do
  let(:instance) { policy }
  let(:options) { {} }

  it "has a max_depth set to 10 by default" do
    value(instance.max_depth).must_equal 10
  end

  describe "#accepts? with only options" do
    it "returns true if the options starts with the path" do
      options = { only: ["/", "/foo/bar"] }

      value(policy(options).accepts?("/")).must_equal true
      value(policy(options).accepts?("/foo")).must_equal true
      value(policy(options).accepts?("/foo/bar")).must_equal true

      value(policy(options).accepts?("/bar")).must_equal false
      value(policy(options).accepts?("/foo/baz")).must_equal false
      value(policy(options).accepts?("/foo/bar/baz")).must_equal false
    end

    it "returns true if the options contains the path" do
      options = { only: ["foo/bar"] }

      value(policy(options).accepts?("/foo/bar")).must_equal true
      value(policy(options).accepts?("/baz/foo/bar/baz")).must_equal true

      value(policy(options).accepts?("/")).must_equal false
      value(policy(options).accepts?("/foo")).must_equal false
    end
  end

  describe "#accepts? with except options" do
    it "returns false if the options is exactly the path" do
      options = { except: ["/foo/bar", "/bar"] }

      value(policy(options).accepts?("/foo/bar")).must_equal false
      value(policy(options).accepts?("/bar")).must_equal false

      value(policy(options).accepts?("/")).must_equal true
      value(policy(options).accepts?("/foo/baz")).must_equal true
      value(policy(options).accepts?("/baz/foo/bar")).must_equal true
    end

    it "returns true if the options contains the path" do
      options = { except: ["foo/bar"] }

      value(policy(options).accepts?("/foo/bar")).must_equal false
      value(policy(options).accepts?("/baz/foo/bar")).must_equal false

      value(policy(options).accepts?("/")).must_equal true
      value(policy(options).accepts?("/foo/baz")).must_equal true
    end
  end

  def policy(options = self.options)
    CherryPick::Policy.new(options)
  end
end

