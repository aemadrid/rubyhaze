module RubyHaze::BaseMixin

  java_import 'com.hazelcast.core.Hazelcast'

  def self.included(base)
    base.extend ClassMethods
  end

  attr_reader :name

  def crc
    @crc ||= RubyHaze.crc @name
  end

  def respond_to?(meth)
    @hco.respond_to?(meth) || super
  end

  def method_missing(meth, *args, &blk)
    if @hco.respond_to? meth
      @hco.send meth, *args, &blk
    else
      super
    end
  end

  def ==(other)
    return false unless other.class.name == self.class.name
    name == other.name
  end

  def rescue_native_exception(exception)                                                                            
    exception = exception.cause while exception.cause
    exception.print_stack_trace
    raise RubyHaze::HazelcastException(exception)
  end
  
  module ClassMethods

    def [](name)
      new(name)
    end

  end

end