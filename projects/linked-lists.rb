
class LinkedList
  def initialize
    @head = nil
  end

  def append(value)

    if @head == nil
      @head = Node.new(value)
      return
    end

    next_node = @head

    until next_node.next_node == nil
      next_node = next_node.next_node
    end

    next_node.set_next_node(Node.new(value))
  end

  def prepend(value)

    if @head == nil
      @head = Node.new(value)
      return
    end

    @head = Node.new(value, @head)

  end

  def size
    count = 0
    next_node = @head

    until next_node == nil
      next_node = next_node.next_node
      count += 1
    end

    count
  end

  def head
    @head
  end

  def tail

    if @head == nil
      return nil
    end

    next_node = @head

    until next_node.next_node == nil
      next_node = next_node.next_node
    end

    next_node

  end

  def at(index)
    
    if @head == nil
      return nil
    end
    
    cur_index = 0
    next_node = @head

    until next_node == nil

      if index == cur_index
        return next_node
      end
      
      cur_index += 1
      next_node = next_node.next_node
    end

    return nil

  end

  def pop
    
    if @head == nil
      return nil
    end

    last_node = nil
    next_node = @head

    until next_node.next_node == nil
      last_node = next_node
      next_node = next_node.next_node
    end

    last_node.set_next_node(nil)

    next_node
  end

  def contains?(value)

    if @head == nil
      return false
    end

    next_node = @head

    until next_node == nil
      if next_node.value == value
        return true
      end

      next_node = next_node.next_node
    end

    false

  end

  def find(value)

    if @head == nil
      return nil
    end

    cur_index = 0
    next_node = @head

    until next_node == nil

      if next_node.value == value
        return cur_index
      end

      cur_index += 1
      next_node = next_node.next_node
    end

    nil

  end

  def to_s
    
    if @head == nil
      return "nil"
    else
      str = "( #{@head.value} )"
    end

    next_node = @head

    until next_node.next_node == nil
      str += " -> ( #{next_node.next_node.value} )"

      next_node = next_node.next_node
    end

    str += " -> nil"

    str
  end

  def insert_at(value, index)

    if @head == nil
      puts "Index > Size."
      return
    end

    cur_index = 0
    last_node = nil
    next_node = @head

    until next_node == nil

      if cur_index == index
        last_node.set_next_node(Node.new(value, next_node))
        return
      end

      cur_index += 1
      last_node = next_node
      next_node = next_node.next_node
    end

    puts "Index > Size."
  end

  def remove_at(index)
    if @head == nil
      puts "Index > Size."
      return nil
    end

    cur_index = 0
    last_node = nil
    next_node = @head

    until next_node == nil

      if cur_index == index
        last_node.set_next_node(next_node.next_node)
        return next_node
      end

      cur_index += 1
      last_node = next_node
      next_node = next_node.next_node
    end

    puts "Index > Size."
    nil
  end

end

class Node
  def initialize(value, next_node = nil)
    @value = value
    @next_node = next_node
  end

  def value
    @value
  end

  def next_node
    @next_node
  end

  def set_next_node(next_node)
    @next_node = next_node
  end
end

def should_equal(ex1, ex2, name)
  puts
  if ex1 == ex2
    puts "Test #{name} Passed!"
  else
    puts "Test #{name} Didn't Pass. #{ex1 ? ex1 : "false / nil"} != #{ex2}"
  end
  puts
end

if __FILE__ == $0

  ll = LinkedList.new

  can_append = "CAN APPEND"

  should_equal(ll.to_s, "nil", "CAN PRINT")

  ll.append(1)

  should_equal(ll.to_s, "( 1 ) -> nil", can_append)

  ll.append(2)

  should_equal(ll.to_s, "( 1 ) -> ( 2 ) -> nil", can_append)

  ll.append(3)

  should_equal(ll.to_s, "( 1 ) -> ( 2 ) -> ( 3 ) -> nil", can_append)

  ll.prepend(0)

  should_equal(ll.to_s, "( 0 ) -> ( 1 ) -> ( 2 ) -> ( 3 ) -> nil", "CAN PREPEND")

  should_equal(ll.size, 4, "CAN GET SIZE")

  should_equal(ll.head.value, 0, "CAN GET HEAD")

  should_equal(ll.tail.value, 3, "CAN GET TAIL")

  should_equal(ll.at(2).value, 2, "CAN GET AT(INDEX)")

  should_equal(ll.pop.value, 3, "CAN POP")

  should_equal(ll.to_s, "( 0 ) -> ( 1 ) -> ( 2 ) -> nil", "POP CAN DELETE")

  should_equal(ll.contains?(2), true, "CAN DO CONTAINS")

  should_equal(ll.contains?(5), false, "CAN DO DOES NOT CONTAIN")

  should_equal(ll.find(2), 2, "CAN FIND VALUE")

  should_equal(ll.find(5), nil, "CAN DETERMINE NO VALUE EXISTS")

  ll.insert_at(5, 1)

  should_equal(ll.to_s, "( 0 ) -> ( 5 ) -> ( 1 ) -> ( 2 ) -> nil", "CAN INSERT AT")

  ll.remove_at(2)

  should_equal(ll.to_s, "( 0 ) -> ( 5 ) -> ( 2 ) -> nil", "CAN REMOVE AT")
end