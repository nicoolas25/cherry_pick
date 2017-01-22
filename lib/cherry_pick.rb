require "cherry_pick/version"

module CherryPick
  extend self

  autoload :Node,     "cherry_pick/node"
  autoload :DSL,      "cherry_pick/dsl"
  autoload :Runner,   "cherry_pick/runner"
  autoload :Fetcher,  "cherry_pick/fetcher"
  autoload :Importer, "cherry_pick/importer"

  def directory
    @directory ||=
      ActiveRecord::Base.subclasses.each_with_object({}) do |klass, result|
        result[klass.name.underscore] = Node.new(klass)
      end
  end

  def within_connection(config)
    previous_config = ActiveRecord::Base.connection_config
    if config == previous_config
      yield
    else
      begin
        ActiveRecord::Base.establish_connection(config)
        yield
      ensure
        ActiveRecord::Base.establish_connection(previous_config)
      end
    end
  end
end
