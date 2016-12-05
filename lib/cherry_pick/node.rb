module CherryPick
  class Node
    def initialize(model, directory)
      @links = {}
      @model = model
      @directory = directory
      explore!
    end

    def related_models
      @links.keys
    end

    private

    def explore!
      @model.reflect_on_all_associations.each do |reflection|
        @links[reflection.klass.table_name] = reflection
      end
    end
  end
end
