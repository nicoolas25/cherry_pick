require "test_helper"

describe CherryPick::Fetcher do
  let(:instance) { CherryPick::Fetcher.new }

  describe "#get" do
    it "accepts an Enumerable of models" do
      instance.get(City.where("name LIKE 'P%'"))
    end
  end

  describe "#policy" do
    it "create a Policy object" do
      result = instance.policy(max_depth: 5)
      value(result).must_be_kind_of(CherryPick::Policy)
      value(result.max_depth).must_equal 5
    end
  end

  describe "#run" do
    def setup
      @paris    = City.create(name: "Paris")
      @mayor    = Mayor.create(beloved_city: @paris)
      @subway   = Subway.create
      @citizens = 2.times.map { Citizen.create(home_city: @paris) }
      @paris.subways << @subway

      query = City.where(name: "Paris")
      instance.get(query)
      instance.policy(policy_options)
    end

    let(:result) { instance.run.map(&:model) }
    let(:policy_options) { { max_depth: max_depth } }
    let(:max_depth) { 10 }

    it "includes the root models and their relations" do
      value(result).must_include @paris
      value(result).must_include @mayor
      value(result).must_include @subway
      value(result).must_include *@citizens
    end

    it "includes the relations of the related models too" do
      rouen = City.create(name: "Rouen")
      rouen.subways << @subway

      value(result).must_include rouen
    end

    it "doesn't include unrelated models" do
      milan = City.create(name: "Milan")

      value(result).wont_include milan
    end

    describe "policy's max_depth is 2" do
      let(:max_depth) { 2 }

      it "doesn't fetch models beyond policy max_depth" do
        rouen = City.create(name: "Rouen")
        rouen.subways << @subway

        value(result).wont_include rouen
      end
    end

    describe "policy's filtering associations with only" do
      let(:policy_options) { { only: [ "/mayor" ] } }

      it "includes only what policy is allowing" do
        value(result).must_include @paris
        value(result).must_include @mayor
        value(result).wont_include @subway
        value(result).wont_include *@citizens
      end
    end

    describe "policy's filtering associations with except" do
      let(:policy_options) { { except: [ "subways/cities" ] } }

      it "includes only what policy is allowing" do
        rouen = City.create(name: "Rouen")
        rouen.subways << @subway

        value(result).must_include @paris
        value(result).must_include @mayor
        value(result).must_include @subway
        value(result).must_include *@citizens
        value(result).wont_include rouen
      end
    end
  end
end
