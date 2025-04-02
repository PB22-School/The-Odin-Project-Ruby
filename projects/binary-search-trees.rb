
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

  def pretty_print(node = self, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

end

class Tree
  def initialize(array)
    @root = nil
    build_tree(merge_sort(array.uniq))
  end

  def build_tree(array, root_call = true)

    if array.length <= 1
      return Node.new(array[0])
    end

    middle = (array.length / 2).to_i

    tree = Node.new(array[middle], build_tree(array[0, middle], false), build_tree(array[middle + 1, array.length - 1], false))

    if root_call
      @root = tree
    end

    return tree

  end

  # from a student of the Odin Project:
  def pretty_print
    @root.pretty_print
  end
end

tree = Tree.new([150, 1024, 12031, 2103, 405, 12, 0, 12, 3, 1, 4,5 ,7, 1, 4, 156])
tree.pretty_print
