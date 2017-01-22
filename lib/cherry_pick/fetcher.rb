module CherryPick
  class Fetcher
    def get(models)
      (@models ||= []).concat(models)
    end

    def run
      space = Set.new(@models)
      queue = Array.new(@models)
      while queue.any?
        current = queue.shift
        relations(current).each do |relation|
          relation.each do |related|
            unless space.include?(related)
              space << related
              queue << related
            end
          end
        end
      end
      space
    end

    private

    def relations(model)
      node = CherryPick.directory[model.class.name.underscore]
      node.relations.map { |relation| Array(model.__send__(relation)) }
    end
  end
end
