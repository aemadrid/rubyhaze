module RubyHaze
  module Mixins
    module Compare

      def ==(other)
        return false unless other.class.name == self.class.name
        name == other.name
      end

    end
  end
end