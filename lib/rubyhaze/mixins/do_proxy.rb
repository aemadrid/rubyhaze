module RubyHaze
  module Mixins
    module DOProxy

      include RubyHaze::Mixins::Proxy
      include RubyHaze::Mixins::Compare
      include RubyHaze::Mixins::NativeException

      java_import 'com.hazelcast.core.Hazelcast'

      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :name

      module ClassMethods

        def [](name)
          new(name)
        end

      end

    end
  end
end