module CherryPick
  class Policy
    attr_reader :max_depth

    def initialize(options = {})
      options = default_options.merge(options)
      @max_depth = options[:max_depth]
      @only = options[:only].map { |str| Rule.new(str) }
      @except = options[:except].map { |str| Rule.new(str) }
    end

    def accepts?(path)
      if @only.any? && @only.none? { |rule| rule.match?(path) }
        false
      elsif @except.any? && @except.any? { |rule| rule.filter?(path) }
        false
      else
        true
      end
    end

    private

    def default_options
      {
        max_depth: 10,
        only: [],
        except: [],
      }
    end

    class Rule
      def initialize(str)
        @str = str
      end

      def filter?(path)
        if @str.start_with?("/")
          @str == path.to_str
        else
          path.to_str.include?(@str)
        end
      end

      def match?(path)
        if @str.start_with?("/")
          @str.start_with?(path.to_str)
        else
          path.to_str.include?(@str)
        end
      end
    end
  end
end
