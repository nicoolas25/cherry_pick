require "test_helper"

describe CherryPick::Fetcher do
  let(:instance) { CherryPick::Fetcher.new }
  let(:query) { City.where(name: "Paris") }

  def setup
    @paris    = City.create(name: "Paris")
    @mayor    = Mayor.create(beloved_city: @paris)
    @subway   = Subway.create
    @citizens = 2.times.map { Citizen.create(home_city: @paris) }
    @paris.subways << @subway

    instance.get(query)
  end

  describe "#run" do
    let(:result) { instance.run }

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
  end
end
