module RubyHaze::BaseMixin

  java_import 'com.hazelcast.core.Hazelcast'

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

end