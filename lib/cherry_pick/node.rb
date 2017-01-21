module CherryPick
  class Node
    def initialize(model, directory)
      @links = {}
      @model = model
      @directory = directory
      explore!
    end

    def relations
      @links.keys
    end

    private

    def explore!
      @model.reflect_on_all_associations.each do |reflection|
        @links[reflection.name.to_s] = reflection
      end
    end
  end
end
