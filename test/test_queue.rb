require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestRubyHazeQueue < Test::Unit::TestCase

  def test_single_queing
    tasks = RubyHaze::Queue[:test_single]
    50.times { |idx| tasks.put [idx, Process.pid] }
    found = []
    while !tasks.empty? do
      task = tasks.poll 5, java.util.concurrent.TimeUnit::SECONDS
      found << task
    end
    assert !found.empty?
    assert_equal found.size, 50
  end

end
