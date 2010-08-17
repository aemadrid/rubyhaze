require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::Queue

  include RubyHaze::Mixins::DOProxy

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_queue @name
  end

end
