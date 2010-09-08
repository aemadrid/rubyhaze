require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Queue

  include RubyHaze::Mixins::DOProxy

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_queue @name
  end

  def poll(timeout = 5, unit = :seconds)
    @proxy_object.poll timeout, java.util.concurrent.TimeUnit.const_get(unit.to_s.upcase)
  end

end
