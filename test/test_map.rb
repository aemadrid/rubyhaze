require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestRubyHazeHash < Test::Unit::TestCase

  java_import 'com.hazelcast.query.SqlPredicate'

  def test_same_object
    hash = RubyHaze::Hash[:test_same_object]
    map = RubyHaze::Map[:test_same_object]
    assert_equal hash.name, map.name
    hash[:a] = 1
    assert_equal hash[:a], map[:a]
  end

  def test_string_keys
    hash = RubyHaze::Map[:test_string_keys]

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

  def test_predicates
    map = RubyHaze::Map[:test_predicates]

    predicate = map.prepare_predicate "active = false AND (age = 45 OR name = 'Joe Mategna')"
    assert_kind_of SqlPredicate, predicate
    assert_equal "(active=false AND (age=45 OR name=Joe Mategna))", predicate.to_s

    predicate = map.prepare_predicate :quantity => 3
    assert_kind_of SqlPredicate, predicate
    assert_equal 'quantity=3', predicate.to_s

    predicate = map.prepare_predicate :country => "Unites States of America"
    assert_kind_of SqlPredicate, predicate
    assert_equal "country=Unites States of America", predicate.to_s
  end

  def test_search
    map = RubyHaze::Map[:test_search]
    map.clear

    @a = Employee.new "Leonardo", 65, true, 1547.5
    @b = Employee.new "Michelangelo", 45, false, 2835.75
    @c = Employee.new "Marcos", 32, false, 0.0

    map[:a] = @a
    map[:b] = @b
    map[:c] = @c

    res = map.find :age => @b.age
    assert_equal res.size, 1
    assert_equal res.first.name, @b.name

    res = map.find :name => @b.name
    assert_equal res.size, 1
    assert_equal res.first.name, @b.name

    res = map.find 'salary > 2000.0'
    assert_equal res.size, 1
    assert_equal res.first.name, @b.name

    res = map.find 'age BETWEEN 40 AND 50'
    assert_equal res.size, 1
    assert_equal res.first.name, @b.name

    res = map.find "name LIKE 'Leo%'"
    assert_equal res.size, 1
    assert_equal res.first.name, @a.name

    # Throws an internal exception
#    res = map.find "age IN (32, 65)"
#    assert_equal res.size, 2
#    names = res.map{|x| x.name }.sort
#    assert_equal names.first, @a.name
#    assert_equal names.last, @b.name

    res = map.find "age < 60 AND name LIKE 'M%'"
    assert_equal res.size, 2
    names = res.map{|x| x.name }.sort
    assert_equal names.first, @c.name
    assert_equal names.last, @b.name

  end

end
