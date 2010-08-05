require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Topic

  include RubyHaze::BaseMixin

  java_import 'com.hazelcast.core.MessageListener'

  def initialize(name)
    @name = name.to_s
    @hco = Hazelcast.get_topic @name
  end

  def on_message(&blk)
    klass = Class.new
    klass.send :include, MessageListener
    klass.send :define_method, :on_message, &blk
    @hco.add_message_listener klass.new
  end

end
