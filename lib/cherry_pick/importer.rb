module CherryPick
  class Importer
    def initialize
      @before_save_blocks ||= {}
    end

    def before_save(klass, &block)
      @before_save_blocks[klass] = block
    end

    def run(nodes)
      CherryPick.log "Importing models..."
      mapping = nodes.each.with_object({}) do |node, mapping|
        node.target_model = write_record(node.model)
        key = [node.model.class.name, node.model.id]
        mapping[key] = node
      end
      CherryPick.log "Importing is done"

      CherryPick.log "Weaving associations..."
      mapping.values.each do |node|
        weave_associations(node, mapping)
      end
      CherryPick.log "Weaving is done"

      mapping
    end

    private

    # Creates a record without validations or callbacks
    def write_record(source_model)
      model = source_model.dup

      # Copy the {created,updated}_at too!
      model.created_at = source_model.created_at if source_model.attribute_names.include?("created_at")
      model.updated_at = source_model.updated_at if source_model.attribute_names.include?("updated_at")

      # Execute the before_save hooks
      if block = @before_save_blocks[model.class]
        block.call(model)
      end

      model.instance_exec do
        # Copied from AR source code doing creation
        attributes_values = arel_attributes_with_values_for_create(attribute_names)
        new_id = self.class.unscoped.insert(attributes_values)
        self.id ||= new_id if self.class.primary_key
        @new_record = false
      end

      model
    end

    def weave_associations(node, mapping)
      source_model = node.model
      target_model = node.target_model
      updates = {}

      node.relations.each do |name|
        case reflection = source_model.class.reflect_on_association(name)
        when ActiveRecord::Reflection::BelongsToReflection
          attribute = reflection.foreign_key
          if related_id = source_model.attributes[attribute]
            key = [ reflection.class_name, related_id ]
            related_model = mapping.fetch(key).target_model
            updates[attribute] = related_model.id
          end
        end
      end

      if updates.any?
        target_model.update_columns(updates)
      end
    end
  end
end
