module CherryPick
  class Node
    attr_reader :model
    attr_reader :path

    attr_accessor :target_model

    def initialize(model, path, policy)
      @model = model
      @path = path
      @policy = policy
    end

    def relations
      return [] if @path.depth >= @policy.max_depth
      entry = CherryPick.directory.fetch(@model.class.name.underscore)
      entry.relations
    end

    def related_nodes
      Enumerator.new do |output|
        relations.map do |relation_name|
          child_models = Array(@model.__send__(relation_name))
          child_models.each do |child_model|
            child_path = Path.after(@path, relation_name)
            child_node = Node.new(child_model, child_path, @policy)
            output.yield(child_node)
          end
        end
      end
    end

    def eql?(other)
      other.is_a?(Node) && @model.eql?(other.model)
    end

    def hash
      @model.hash
    end
  end
end
