require File.expand_path(File.dirname(__FILE__) + '/helper')
require 'forwardable'

class TestListener
  def initialize(name)
    @name = name
  end
  def on_message(msg)
    Notices << "[#{@name}] #{msg}"
  end
end

class TestRubyHazeTopic < Test::Unit::TestCase

  def test_block_listener
    Notices.clear
    topic = RubyHaze::Topic[:test1]
    topic.on_message do |msg|
      Notices << "#{msg}"
    end
    assert_equal Notices.size, 0
    topic.publish "Hola!"
    assert_equal Notices.size, 1
  end

end
