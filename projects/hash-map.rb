
require "./linked-lists.rb"

# this hash function is from the Odin-Project
def hash(key)
  hash_code = 0
  prime_number = 31

  key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
  
  hash_code
end

class HashMap

  def initialize
    @load_factor = 0.75
    @capacity = 16
    @buckets = Array.new(@capacity, nil)
  end

  def get_bucket(index)
    raise IndexError if index.negative? || index >= @buckets.length

    return @buckets[index]
  end

  def set(key, value)
    hash_code = hash(key) % @capacity
    bucket = get_bucket(hash_code)

    # if I were making this for real, I'd make a new linked list that supported two values, (key, value).
    # But I just did that exercise and I don't feel like making a new linked list type.

    if bucket == nil

      if length >= @capacity * @load_factor
        (@capacity * 2).times { @buckets << nil }
        @capacity *= 2
      end

      @buckets[hash_code] = LinkedList.new
    end

    @buckets[hash_code].append(key)
    @buckets[hash_code].append(value)
  end

  def get(key)
    hash_code = hash(key) % @capacity
    bucket = get_bucket(hash_code)

    if bucket == nil
      return nil
    end

    start_index = 0
    while start_index < bucket.size
      if bucket.at(start_index) == key
        return bucket.at(start_index + 1)
      end

      start_index += 2
    end

    return nil
  end

  def has?(key)

    # return get(key) != nil

    hash_code = hash(key) % capacity
    bucket = get_bucket(hash_code)

    if bucket == nil
      return false
    end

    start_index = 0
    while start_index < bucket.size
      if bucket.at(start_index) == key
        return true
      end
      
      start_index += 2
    end

    false
  end

  def remove(key)

    hash_code = hash(key) % capacity
    bucket = get_bucket(hash_code)

    if bucket == nil
      return nil
    end

    start_index = 0
    while start_index < bucket.size
      if bucket.at(start_index) == key
        # gets rid of the key
        bucket.remove_at(start_index)

        # gets rid of (and returns) the value
        return bucket.remove_at(start_index).value
      end

      start_index += 2
    end

    nil
  end

  def length
    return @buckets.count { |bucket| bucket != nil }
  end

  def clear
    # this might cause memory issues..? (because of linked lists???)
    @buckets.clear
  end

  def keys
    
    all_keys = []

    for bucket in @buckets

      if bucket == nil
        next
      end

      start_index = 0
      while start_index < bucket.size
        all_keys.push(bucket.at(start_index).value)
        start_index += 2
      end
    end

    all_keys
  end

  def values
    
    all_values = []

    for bucket in @buckets

      if bucket == nil
        next
      end

      start_index = 1
      while start_index < bucket.size
        all_values.push(bucket.at(start_index).value)
        start_index += 2
      end
    end

    all_values
  end

  def entries
    # there's probably something I can do with the #keys and #values but I'll do it the right way:

    all_entries = []

    for bucket in @buckets

      if bucket == nil
        next
      end

      start_index = 0
      while start_index < bucket.size
        all_entries.push([bucket.at(start_index).value, bucket.at(start_index + 1).value])
        start_index += 2
      end
    end

    all_entries
  end

  def get_load_level
    return length / (@capacity * @load_factor)
  end

  def capacity
    @capacity
  end

end

test = HashMap.new
test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

p test.keys
p test.values

puts "Load Level: #{test.get_load_level}"

# this should cause a double in capacity:
# (if I did it with nested arrays, not nested linked lists..)
test.set('moon', 'silver')

puts "Load Level: #{test.get_load_level}"
puts "Capacity (started at 16) : #{test.capacity}"