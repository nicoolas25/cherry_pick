module CherryPick
  class Importer
    def initialize
      @before_save_blocks ||= {}
    end

    def before_save(klass, &block)
      @before_save_blocks[klass] = block
    end

    def run(models)
      CherryPick.log "Importing models..."
      mapping = models.each.with_object({}) do |source_model, mapping|
        key = [source_model.class.name, source_model.id]
        mapping[key] = [source_model, write_record(source_model)]
      end
      CherryPick.log "Importing is done"

      CherryPick.log "Weaving associations..."
      mapping.values.each do |source_model, target_model|
        weave_associations(source_model, target_model, mapping)
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

    def weave_associations(source_model, target_model, mapping)
      updates = {}

      node = CherryPick.directory[source_model.class.name.underscore]
      node.relations.each do |name|
        case reflection = source_model.class.reflect_on_association(name)
        when ActiveRecord::Reflection::BelongsToReflection
          attribute = reflection.foreign_key
          related_id = source_model.attributes[attribute]
          key = [ reflection.class_name, related_id ]
          related_model = mapping.fetch(key).second
          updates[attribute] = related_model.id
        end
      end

      if updates.any?
        target_model.update_columns(updates)
      end
    end
  end
end
