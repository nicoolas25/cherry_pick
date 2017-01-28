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
      space = Set.new(@models)
      queue = Array.new(@models.map { |model| Todo.new(model, "/") })
      while queue.any?
        current = queue.shift
        next if current.depth >= @policy.max_depth
        relations(current.model).each do |relation, name|
          relation.each do |related|
            unless space.include?(related)
              space << related
              queue << Todo.new(related, "#{current.path}#{name}/")
            end
          end
        end
      end
      CherryPick.log "Data is in memory: #{space.size} objects"
      space
    end

    private

    def relations(model)
      node = CherryPick.directory.fetch(model.class.name.underscore)
      node.relations.map do |relation_name|
        [ Array(model.__send__(relation_name)), relation_name ]
      end
    end

    Todo = Struct.new(:model, :path) do
      def depth
        path.count("/")
      end
    end
  end
end
