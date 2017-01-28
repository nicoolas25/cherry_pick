module CherryPick
  class Policy
    attr_reader :max_depth

    def initialize(options = {})
      options = default_options.merge(options)
      @max_depth = options[:max_depth]
      @only = options[:only]
      @except = options[:except]
    end

    private

    def default_options
      {
        max_depth: 20,
        only: [],
        except: [],
      }
    end
  end
end
