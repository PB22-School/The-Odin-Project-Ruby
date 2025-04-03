
def is_valid_square(sqr)
  return (sqr[0] >= 0 and sqr[0] < 8 and sqr[1] >= 0 and sqr[1] < 8)
end

def possible_moves(from)

  moves = []

  for i in [-1, 1]
    for j in [-1, 1]

      move_1 = [from[0] + (2 * i), from[1] + j]
      move_2 = [from[0] + i, from[1] + (2 * j)]

      if is_valid_square(move_1)
        moves.push(move_1)
      end

      if is_valid_square(move_2)
        moves.push(move_2)
      end

    end
  end

  moves

end

# I'm pretty sure I do it with a tree, not a graph..?
def knight_moves(from, to)

  if from == to
    return 0
  end

  unless is_valid_square(from)
    puts "INVALID START SQUARE."
    return
  end

  unless is_valid_square(to)
    puts "INVALID END SQUARE"
    return
  end

  # should just be a breath-first search until we find the correct position.
  full_steps = [from]
  queue = []
  
  # [possible_moves_from_position, depth]
  queue.push([possible_moves(from), 0, [from]])

  loop do
    current_pos_moves = queue.shift
    depth = current_pos_moves[1]
    parent_moves = current_pos_moves[2]
    current_pos_moves = current_pos_moves[0]
    parent_moves.push([])

    for move in current_pos_moves

      parent_moves[depth + 1] = move

      if move == to
        return parent_moves
      end

      queue.push([possible_moves(move), depth + 1, parent_moves.dup])
    end
  end
end

puts "MOVES: " + knight_moves([0,0],[7,7]).to_s