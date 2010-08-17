module RubyHaze
  module Mixins
    module NativeException

      def rescue_native_exception(exception)
        exception = exception.cause while exception.cause
        exception.print_stack_trace
        raise RubyHaze::HazelcastException(exception)
      end

    end
  end
end