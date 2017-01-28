require "test_helper"

describe CherryPick::Path do
  it "can't be .new-ed" do
    proc { CherryPick::Path.new }.must_raise NoMethodError
  end

  describe ".root" do
    let(:instance) { CherryPick::Path.root }

    it "creates a Path instance" do
      value(instance).must_be_kind_of CherryPick::Path
    end

    it "creates a root instance" do
      value(instance.root?).must_equal true
      value(instance.depth).must_equal 1
    end

    it "creates a path equivalent to '/'" do
      value(instance.to_str).must_equal "/"
    end
  end

  describe ".after(path, name)" do
    let(:instance) { CherryPick::Path.after(path, "name") }
    let(:root) { CherryPick::Path.root }

    describe "path is root" do
      let(:path) { root }

      it "creates a path equivalent to '/name'" do
        value(instance.to_str).must_equal "/name"
      end

      it "is deeper by one from path" do
        value(instance.depth).must_equal(path.depth + 1)
      end

      it "creates a non-root instance" do
        value(instance.root?).must_equal false
      end
    end

    describe "path isn't root" do
      let(:path) { CherryPick::Path.after(root, "parent") }

      it "creates a path equivalent to '/parent/name'" do
        value(instance.to_str).must_equal "/parent/name"
      end

      it "is deeper by one from path" do
        value(instance.depth).must_equal(path.depth + 1)
      end

      it "creates a non-root instance" do
        value(instance.root?).must_equal false
      end
    end
  end
end

