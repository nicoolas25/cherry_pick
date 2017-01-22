module CherryPick
  class DSL
    attr_reader :source_db_config
    attr_reader :target_db_config
    attr_reader :fetch_block
    attr_reader :import_block


    def source_db(source_db_config)
      @source_db_config = source_db_config
    end

    def target_db(target_db_config)
      @target_db_config = target_db_config
    end

    def fetch(&fetch_block)
      @fetch_block = fetch_block
    end

    def import(&import_block)
      @import_block = import_block
    end
  end
end

