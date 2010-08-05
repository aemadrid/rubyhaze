require File.expand_path(File.dirname(__FILE__) + '/../lib/rubyhaze')
require 'test/unit'

class Foo
  include RubyHaze::Stored
  field :name, :string
  field :age, :int
end unless defined? Foo

class TestRubyHazeStoredClassMethods < Test::Unit::TestCase

  def test_right_store
    store = Foo.store
    assert_equal store.class.name, "RubyHaze::Map"
    assert_equal store.name, "RubyHaze_Shadow__Foo"
    assert_equal store.name, RubyHaze::Map.new("RubyHaze_Shadow__Foo").name
  end

  def test_right_fields
    fields = Foo.fields
    assert_equal fields, [[:uid, :string, {}], [:name, :string, {}], [:age, :int, {}]]
    assert_equal Foo.field_names, [:uid, :name, :age]
    assert_equal Foo.field_types, [:string, :string, :int]
    assert_equal Foo.field_options, [{}, {}, {}]
  end

  def test_right_shadow_class
    assert_equal Foo.store_java_class_name, "RubyHaze_Shadow__Foo"
    assert_equal Foo.store_java_class.name, "Java::Default::RubyHaze_Shadow__Foo"

  end

end

class TestRubyHazeStoredStorage < Test::Unit::TestCase

  def test_store_reload_objects
    Foo.store.clear
    assert_equal Foo.store.size, 0
    @a = Foo.create :name => "Leonardo", :age => 65
    assert_equal Foo.store.size, 1
    @b = Foo.create :name => "Michelangelo", :age => 45
    assert_equal Foo.store.size, 2
    @b.age = 47
    @b.reload
    assert_equal Foo.store.size, 2
    assert_equal @b.age, 45
    Foo.store.clear
    assert_equal Foo.store.size, 0
  end

  def test_find_through_predicates
    Foo.store.clear
    @a = Foo.create :name => "Leonardo", :age => 65
    @b = Foo.create :name => "Michelangelo", :age => 45
    @c = Foo.create :name => "Raffaello", :age => 32

    res = Foo.find 'age < 40'
    assert_equal res.size, 1
    assert_equal res.first, @c
    assert_equal res.first.name, @c.name

    res = Foo.find 'age BETWEEN 40 AND 50'
    assert_equal res.size, 1
    assert_equal res.first, @b
    assert_equal res.first.name, @b.name

    res = Foo.find "name LIKE 'Leo%'"
    assert_equal res.size, 1
    assert_equal res.first, @a
    assert_equal res.first.name, @a.name

#    res = Foo.find "age IN (32, 65)"
#    assert_equal res.size, 2
#    names = res.map{|x| x.name }.sort
#    assert_equal names.first, @a.name
#    assert_equal names.last, @b.name

    res = Foo.find "age < 40 AND name LIKE '%el%'"
    assert_equal res.size, 1
    assert_equal res.first, @c
    assert_equal res.first.name, @c.name
  end

end
