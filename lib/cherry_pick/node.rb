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
      all_relations.select { |name| @policy.accepts?(@path << name) }
    end

    def related_nodes
      Enumerator.new do |output|
        relations.map do |relation_name|
          child_models = Array(@model.__send__(relation_name))
          child_models.each do |child_model|
            child_path = @path << relation_name
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

    private

    def all_relations
      CherryPick.directory.fetch(@model.class.name.underscore).relations
    end
  end
end
