class RubyHaze::FakeStore

  java_import 'com.hazelcast.core.MapStore'

  include MapStore

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