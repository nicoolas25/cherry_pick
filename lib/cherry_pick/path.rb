module CherryPick
  class Path
    attr_reader :depth

    def initialize(path_str, depth)
      @path_str = path_str
      @depth = depth
    end

    def match(rule)
      # TODO
    end

    def to_str
      @path_str
    end

    def root?
      @path_str == "/"
    end

    def <<(association_name)
      self.class.after(self, association_name)
    end

    private_class_method :new

    def self.root
      new("/", 1)
    end

    def self.after(path, association_name)
      new_path = path.root? ?
        "#{path.to_str}#{association_name}" :
        "#{path.to_str}/#{association_name}"
      new(new_path, path.depth + 1)
    end
  end
end
