module RubyHaze
  module Mixins
    module Proxy

      def self.included(base)
        base.extend ClassMethods
      end

      attr_reader :proxy_object

      def respond_to?(meth)
        proxy_object.respond_to?(meth) || super
      end

      def method_missing(meth, *args, &blk)
        if proxy_object.respond_to? meth
          proxy_object.send meth, *args, &blk
        else
          super
        end
      end

      module ClassMethods

        def proxy_accessor(from, to = nil)
          to ||= from
          class_eval %{def #{from}() proxy_object.send :get_#{to} end}
          class_eval %{def #{from}=(v) proxy_object.send :set_#{to}, v end}
        end

        def proxy_accessors(*args)
          args.each { |arg| proxy_accessor *arg }
        end

      end

    end
  end
end