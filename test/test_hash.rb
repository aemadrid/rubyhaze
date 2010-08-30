require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestRubyHazeHash < Test::Unit::TestCase

  def test_same_object
    hash = RubyHaze::Hash[:test_same_object]
    map = RubyHaze::Map[:test_same_object]
    assert_equal hash.name, map.name
    hash[:a] = 1
    assert_equal hash[:a], map[:a]
  end

  def test_string_keys
    hash = RubyHaze::Hash[:test_string_keys]

    hash[:a] = 1
    assert_equal hash['a'], 1
    assert_equal hash[:a], 1

    hash['b'] = 2
    assert_equal hash[:b], 2

    hash[Date.new(2010, 3, 18)] = 3
    assert_equal hash['2010-03-18'], 3

    hash[4] = 4
    assert_equal hash['4'], 4
    assert_equal hash[4], 4
  end

end
