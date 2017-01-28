module CherryPick
  class Fetcher
    def initialize
      @policy = Policy.new
    end

    def get(models)
      (@models ||= []).concat(models)
    end

    def policy(options)
      @policy = Policy.new(options)
    end

    def run
      CherryPick.log "Fetching relations..."
      nodes = @models.map { |model| Node.new(model, Path.root, @policy) }
      space = Set.new(nodes)
      queue = Array.new(nodes)
      while queue.any?
        current_node = queue.shift
        current_node.related_nodes.each do |child_node|
          unless space.include?(child_node)
            space << child_node
            queue << child_node
          end
        end
      end
      CherryPick.log "Data is in memory: #{space.size} objects"
      space
    end
  end
end
