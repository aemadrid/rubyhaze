require File.expand_path(File.dirname(__FILE__) + '/helper')

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

class TestRubyHazeStoredStorage

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
    res = Foo.find 'age > 50'
    assert_equal res.size, 1
    assert_equal res.first, @b
    res = Foo.find 'BETWEEN 40 AND 50'
    assert_equal res.size, 1
    assert_equal res.first, @b
    res = Foo.find "name LIKE 'Leo%'"
    assert_equal res.size, 1
    assert_equal res.first, @a
    res = Foo.find "age IN (32, 65)"
    assert_equal res.size, 2
    res.first.should_include @a
    res.first.should_include @b
    res = Foo.find "age < 40 AND name LIKE '%el%'"
    assert_equal res.size, 1
    assert_equal res.first, @c
  end
  
end
