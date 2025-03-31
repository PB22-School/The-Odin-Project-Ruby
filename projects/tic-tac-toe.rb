
module Pieces
  NONE = 0
  Xs = 1
  Os = 2
end

class Board

  def initialize
    @board = Array.new(9, 0)
    @turn = Pieces::Xs
  end

  def move(loc)
    @board[loc] = @turn
    @turn = 3 - @turn
  end

  def X_win
    puts "Xs Won The Game!"
    print_board
  end

  def O_win
    puts "Os Won The Game!"
    print_board
  end

  def tie
    puts "The Game Ended In A Tie!"
    print_board
  end

  def game_over?
    
    # diagonal win checking
    r_diagonal = [@board[0], @board[4], @board[8]]
    l_diagonal = [@board[2], @board[4], @board[6]]

    if r_diagonal.all? { |val| val == Pieces::Xs } or l_diagonal.all? { |val| val == Pieces::Xs }
      self.X_win
      return true
    elsif l_diagonal.all? { |val| val == Pieces::Os } or l_diagonal.all? { |val| val == Pieces::Os }
      self.O_win
      return true
    end

    for i in (0...3)

      # horizontal win checking
      # puts ((i * 3)...((i + 1) * 3)).to_a.inspect
      row = @board[(i * 3)...((i + 1) * 3)]

      # vertical win checking
      column = [@board[i], @board[i + 3], @board[i + 6]]


      if row.all? { |val| val == Pieces::Xs } or column.all? { |val| val == Pieces::Xs }
        self.X_win
        
        return true
      elsif row.all? { |val| val == Pieces::Os } or column.all? { |val| val == Pieces::Os } 
        self.O_win
        return true
      end

      if @board.none? { |val| val == Pieces::NONE }
        self.tie
        return true
      end
    end
    
    return false

  end

  def print_board
    puts

    for i in (0...3)

      for j in (0...3)

        print case @board[(i * 3) + j]
          when Pieces::Xs then " X"
          when Pieces::Os then " O"
          else " ."
        end 

        unless j >= 2
          print " |"
        end
      end

    print "\n"

    unless i >= 2

      for i in (0..10)
        print "-"
      end

    end

    puts

    end
  end

  def get_next_move

    print_board

    new_move = -1

    until (new_move >= 0 and new_move < 9) and @board[new_move] == Pieces::NONE

      print "\nWhere Do You Want To Move? (0,0 -> 0) : "

      new_move = gets.chomp.to_i

    end

    move(new_move)
  end

end

board = Board.new()

until board.game_over?
  board.get_next_move
end