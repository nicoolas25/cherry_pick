module CherryPick
  class DirectoryEntry
    attr_accessor :relations

    def initialize(klass)
      @relations = klass.reflect_on_all_associations.map(&:name).map(&:to_s)
    end
  end
end
