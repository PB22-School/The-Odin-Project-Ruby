module Enumerable
  # Your code goes here
  def my_each_with_index
    0.upto(self.length - 1) do |i|
      yield self[i], i
    end

    return self
  end

  def my_select
    ret = []
    for i in self
      if yield i
        ret << i
      end
    end

    ret
  end

  def my_all?
    for i in self
      unless yield i
        return false
      end
    end

    true
  end

  def my_any?
    for i in self
      if yield i
        return true
      end
    end

    false
  end

  def my_none?
    for i in self
      if yield i
        return false
      end
    end

    true
  end

  def my_count
    unless block_given?
      return self.length
    end

    count = 0

    for i in self
      if yield i
        count += 1
      end
    end

    count
  end

  def my_map
    new_arr = []

    for i in self
      new_arr.push(yield i)
    end

    new_arr
  end

  def my_inject(initial_val = nil)

    for i in self
      initial_val = yield initial_val, i
    end

    initial_val
  end

end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    for i in self
      yield i
    end

    return self
  end
end
