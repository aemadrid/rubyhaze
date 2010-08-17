class RubyHaze::FakeStore

  java_import 'com.hazelcast.core.MapLoader'
  java_import 'com.hazelcast.core.MapStore'

  include MapStore
  include MapLoader

  def load(key)
    puts "[FakeStore] Loading key [#{key}]"
  end

  def load_all(keys)
    puts "[FakeStore] Loading #{keys.size} keys"
    keys.each { |key| load key }
  end

  def delete(key)
    puts "[FakeStore] Deleting key [#{key}]"
  end

  def delete_all(keys)
    puts "[FakeStore] Deleting #{keys.size} keys"
    keys.each { |key| delete key }
  end

  def store(key, value)
    puts "[FakeStore] Storing key [#{key}] value [#{value}]"
  end

  def store_all(map)
    puts "[FakeStore] Storing #{map.size} key/values"
    map.each { |key, value| store key, value }    
  end
  
end