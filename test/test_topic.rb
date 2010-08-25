require File.expand_path(File.dirname(__FILE__) + '/helper')

class Notices
  class << self
    extend Forwardable
    def all
      @all ||= []
    end
    def_delegators :all, :size, :<<, :first, :last, :clear, :map
  end
end unless defined? Notices

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
    topic = RubyHaze::Topic[:test_block]
    topic.on_message do |msg|
      Notices << "#{msg}"
    end
    assert_equal Notices.size, 0
    topic.publish "Hola!"
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "Hola!"
  end

  def test_class_listener
    Notices.clear
    topic = RubyHaze::Topic[:test_class]
    topic.add_message_listener TestListener.new("test_class")
    assert_equal Notices.size, 0
    topic.publish "Hola!"
    sleep 0.25
    assert_equal Notices.size, 1
    assert_equal Notices.last, "[test_class] Hola!"
  end

  def test_class2_listener
    Notices.clear
  end
end
