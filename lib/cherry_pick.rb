require "cherry_pick/version"

module CherryPick
  extend self

  autoload :Node, "cherry_pick/node"
  autoload :DSL,  "cherry_pick/dsl"

  def directory
    @directory ||=
      ActiveRecord::Base.subclasses.each_with_object({}) do |klass, result|
        result[klass.name.underscore] = Node.new(klass, result)
      end
  end
end
