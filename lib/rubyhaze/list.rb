require File.expand_path(File.dirname(__FILE__) + '/../../lib/rubyhaze')

class RubyHaze::List

  include RubyHaze::Mixins::DOProxy

  def initialize(name)
    @name = name.to_s
    @proxy_object = Hazelcast.get_list @name
  end

end
