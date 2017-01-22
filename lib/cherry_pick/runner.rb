module CherryPick
  class Runner
    attr_reader :dsl

    def initialize(config_file_content, base = ActiveRecord::Base)
      @base = base

      @dsl = DSL.new
      @dsl.instance_eval(config_file_content)

      raise ArgumentError, "fetch block must be given" unless @dsl.fetch_block
      @fetcher = Fetcher.new
      @fetcher.instance_exec(&@dsl.fetch_block)

      @importer = Importer.new
      @importer.instance_exec(&@dsl.import_block) if @dsl.import_block
    end

    def run
      CherryPick.within_connection(@dsl.source_db_config) do
        models = @fetcher.run
        CherryPick.within_connection(@dsl.target_db_config) do
          results = @importer.run(models)
        end
      end
    end
  end
end
