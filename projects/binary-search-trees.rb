
def merge_sort(array)
  
  if array.length == 1
    return array
  end

  middle = (array.length / 2).to_i

  small_1 = merge_sort(array[0, middle])
  small_2 = merge_sort(array[middle, array.length - 1])

  array_to_return = []

  until small_1.size == small_2.size and small_1.size == 0
    if small_1.size == 0
      array_to_return.push(small_2.shift)
    elsif small_2.size == 0
      array_to_return.push(small_1.shift)
    elsif small_1[0] < small_2[0]
      array_to_return.push(small_1.shift)
    else
      array_to_return.push(small_2.shift)
    end
  end

  return array_to_return

end

def max(a, b)
  return a < b ? b : a
end

def abs(x)

  if x == 0
    return 0
  end

  return x^2 / x
end

class Node
  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def data
    @data
  end

  def left
    @left
  end

  def right
    @right
  end

  def set_left(new_left)
    @left = new_left
  end

  def set_right(new_right)
    @right = new_right
  end

  def set_data(new_data)
    @data = new_data
  end

  def pretty_print(node = self, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data ? node.data : "nil"}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

class Tree
  def initialize(array)
    @root = nil
    build_tree(merge_sort(array.uniq))
    p merge_sort(array.uniq)
  end

  def build_tree(array, root_call = true)

    if array.length <= 1
      return Node.new(array[0])
    end

    middle = (array.length / 2).to_i

    #left_node  = middle > 0 ? build_tree(array[0, middle], false) : nil
    #right_node = ((array.length - 1) - middle) > 0 ? build_tree(array[middle + 1, array.length - 1], false) : nil

    if middle > 0
      left_node = build_tree(array[0, middle], false)
    else
      left_node = nil
    end

    if (array.length - 1) - middle > 0
      right_node = build_tree(array[middle + 1, array.length - 1], false)
    else
      right_node = nil
    end

    tree = Node.new(array[middle], left_node, right_node)

    if root_call
      @root = tree
    end

    return tree

  end

  # not 100% if this is implemented correctly
  def insert(value)
    
    cur_node = @root

    loop do

      if value > cur_node.data

        if cur_node.right == nil
          cur_node.set_right(Node.new(value))
          break
        end

        cur_node = cur_node.right
      else

        if cur_node.left == nil
          cur_node.set_left(Node.new(value))
          break
        end

        cur_node = cur_node.left
      end
    end
  end

  def find(value, start_node = @root)

    # loops until it finds a leaf node
    while start_node.left and start_node.right
      if value > start_node.data
        start_node = start_node.right
      elsif value < start_node.data
        start_node = start_node.left
      end
    end

    if start_node.value == value
      return start_node
    else
      return nil
    end

  end

  def remove_helper(last_node, remove_node)

    # is left if the node to remove is smaller than it's parent
    is_left = (last_node.data - remove_node.data) > 0

    if remove_node.left and remove_node.right
      # if the node has two children, find the next biggest node and move it here.

      parent = last_node
      start_node = remove_node

      while start_node.right and start_node.left

        parent = start_node

        # non-exact, prefers bigger numbers
        if remove_node.data < start_node.data
          start_node = start_node.left
        else
          start_node = start_node.right
        end

      end

      val_next = start_node.data
      remove_helper(parent, start_node)
      remove_node.set_data(val_next)

    elsif remove_node.left or remove_node.right

      if remove_node.left
        child = remove_node.left
      else
        child = remove_node.right
      end

      child_val = child.data
      remove_helper(remove_node, child)
      remove_node.set_data(child_val)

    else
      # remove a leaf node
      if is_left
        last_node.set_left(nil)
      else
        last_node.set_right(nil)
      end
    end

    
  end

  def delete(value)
    
    cur_node = @root

    loop do

      if value > cur_node.data

        if cur_node.right.data == value
          ret_node = cur_node.right
          remove_helper(cur_node, cur_node.right)
          return ret_node
        end

        cur_node = cur_node.right

      elsif value < cur_node.data
        
        if cur_node.left.data == value
          ret_node = cur_node.left
          remove_helper(cur_node, cur_node.left)
          return ret_node
        end
        
        cur_node = cur_node.left
      end
    end

  end

  def level_order(node = @root, &block)

    if not block
      ret_arr = []
    end

    queue = []
    queue.push(node)

    while queue.size != 0
      current_node = queue.shift

      if not block
        ret_arr.push(current_node.data)
      else
        block.yield current_node.data
      end

      if current_node.left
        queue.push(current_node.left)
      end

      if current_node.right
        queue.push(current_node.right)
      end

    end

    if not block
      return ret_arr
    end

  end

  # self before children
  def preorder(node = @root, &block)

    block.yield node

    if node.left
      preorder(node.left, &block)
    end

    if node.right
      preorder(node.right, &block)
    end
  end

  # self between children (sorted)
  def inorder(node = @root, &block)
    
    if node.left
      inorder(node.left, &block)
    end

    block.yield node

    if node.right
      inorder(node.right, &block)
    end

  end

  # self after children
  def postorder(node = @root, &block)

    if node.left
      postorder(node.left, &block)
    end

    if node.right
      postorder(node.right, &block)
    end

    block.yield node

  end

  def height(node = @root)

    biggest = 0

    if node.left
      biggest = height(node.left) + 1
    end

    if node.right
      new_size = height(node.right) + 1

      if new_size > biggest
        biggest = new_size
      end
        
    end

    biggest

  end

  def depth(node)

    start_node = @root
    c_depth = 0

    until start_node.data == node.data

      c_depth += 1

      if node.data > start_node.data
        start_node = start_node.right
      else 
        start_node = start_node.left
      end

    end

    c_depth

  end

  def balanced?(node = @root)

    if node.left
      unless balanced?(node.left)
        return false
      end
    end

    if node.right
      unless balanced?(node.right)
        return false
      end
    end

    # "A balanced tree is one where the difference between heights of left subtree and right subtree of every node is not more than 1."

    if node.right and node.left
      if (height(node.left) - height(node.right)) > 1
        return false
      end
    end

    return true
  end

  def rebalance
    new_arr = []
    inorder { |node| new_arr.push(node.data) }

    build_tree(new_arr)
  end

  # from a student of the Odin Project:
  def pretty_print
    @root.pretty_print
  end
end

random_array = Array.new(15) { rand(1..100) }

tree = Tree.new(random_array)

tree.pretty_print

puts tree.balanced?

puts "level order: "
arr = []
tree.level_order { |data| arr.push(data) }
p arr

puts "pre: "
arr = []
tree.preorder { |node| arr.push(node.data) }
p arr

puts "in order: "
arr = []
tree.inorder { |node| arr.push(node.data) }
p arr

puts "post order:"
arr = []
tree.postorder { |node| arr.push(node.data) }
p arr

5.times do 
  tree.insert(rand(101..200))
end

puts "Should be false: "
puts tree.balanced?

puts "rebalancing.."
tree.rebalance

puts "Should be true: "
puts tree.balanced?

tree.pretty_print

puts "level order: "
arr = []
tree.level_order { |data| arr.push(data) }
p arr

puts "pre: "
arr = []
tree.preorder { |node| arr.push(node.data) }
p arr

puts "in order: "
arr = []
tree.inorder { |node| arr.push(node.data) }
p arr

puts "post order:"
arr = []
tree.postorder { |node| arr.push(node.data) }
p arr