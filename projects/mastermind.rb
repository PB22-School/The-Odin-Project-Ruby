
module Colors
  RED = 'R'
  YELLOW = 'Y'
  BLUE = 'B'
  GREEN = 'G'
  ORANGE = 'O'
  WHITE = 'W'
  PURPLE = 'P'
  TURQOUISE = 'T'
end

module Responses
  CORRECT = 'C'
  WRONG = 'W'
end

$colors_list = [Colors::RED, Colors::YELLOW, Colors::BLUE, Colors::GREEN, Colors::ORANGE, Colors::WHITE, Colors::PURPLE, Colors::TURQOUISE]

def random_answer(rules)
  if rules.repeats
    # repeats allowed
    return rules.rows.times.map { $colors_list[rand($colors_list.length)] }
  else
    
    answer = []
    
    possible_colors = $colors_list
    until answer.length == rules.rows
      answer.push(possible_colors[rand(possible_colors.length)])
      possible_colors -= answer
    end

    return answer

  end
end

def get_guess(rules)

  guess = ""
  cleaned_guess = []

  while guess == ""
    print "Enter A " + rules.rows.to_s + " Long String Of Any: RYBGOWPT" + (rules.repeats ? " (repeats enabled)" : " (repeats not enabled)") + " : "
    
    guess = gets.chomp
    
    if guess.length != rules.rows
      guess = ""
      next
    end

    0.upto(guess.length - 1) do |color|

      if $colors_list.include?(guess[color])

        unless rules.repeats
          # if repeats aren't enabled, check if there's a repeat
          if cleaned_guess.include?(guess[color])
            cleaned_guess.clear
            break
          end

        end

        cleaned_guess.push(guess[color])
      else
        cleaned_guess.clear
        break
      end
    end

    if cleaned_guess.length != rules.rows
      guess = ""
      next
    end

  end

  cleaned_guess

end

class Rules
  def initialize(rows = 4, guesses = 12, repeats = false)
    @rows = rows
    @guesses = guesses
    @repeats = repeats
  end

  def rows
    @rows
  end

  def guesses
    @guesses
  end

  def repeats
    @repeats
  end
end

class Board
  def initialize(rules, guesser, correct_answer)
    @rules = rules
    @guesser = guesser
    @correct_answer = correct_answer
    @guesses = []
  end

  def print_board
    puts @guesser ? "Your Guesses:" : "AI's Guesses:"
    puts "C: Correct Color, Correct Place."
    puts "W: Correct Color, Wrong Place."
    puts

    # prints the unused guesses
    0.upto(@rules.guesses - (@guesses.length + 1)) do
      0.upto(@rules.rows - 1) do
        print " . "
      end

      print "  "

      0.upto(@rules.rows - 1) do
        print "."
      end

      puts
      
    end

    unless @guesses
      return
    end

    # prints the used guesses
    for guess in @guesses
      for color in guess
        print ' ' + color + ' '
      end

      print "  "

      print evaluate_guess(guess)

      puts
    end

    puts

  end

  def accept_guess
    @guesses.unshift(get_guess(@rules))
  end

  def make_guess(guess)
    @guesses.unshift(guess)
  end

  def is_game_over?

    print_board

    if @guesses.length == @rules.guesses
      if @guesser
        puts "\nYou Ran Out Of Guesses!!"
        puts
      else
        puts "\nThe AI Ran Out Of Guesses!!"
        puts
      end
      
      return true

    end

    if @guesses.length == 0
      return false
    end

    0.upto(@rules.rows - 1) do |i|
      if @guesses[0][i] != @correct_answer[i]
        return false
      end
    end

    if @guesser
      puts "\nYou Guessed The Correct Pattern!!"
      puts
    else
      puts "\nThe AI Guessed The Correct Pattern!!"
      puts
    end

    true

  end

  def evaluate_guess(guess = @guesses[-1])

    if @guesses.length == 0
      return ""
    end

    response = ""

    0.upto(@correct_answer.length - 1) do |i|

      right_color = @correct_answer[i]
      guessed_color = guess[i]

      if right_color == guessed_color
        response += Responses::CORRECT
      elsif @correct_answer.any? { |val| val == guessed_color }
        response += Responses::WRONG
      else
        response += '.'
      end

    end

    response

  end

  def last_guess
    if @guesses
      return @guesses[0]
    else
      return nil
    end
  end


end

class AI

  def initialize(rules, board)
    @rules = rules
    @board = board

    # correct colors at the correct position
    @corrects = Array.new(rules.rows, -1)

    # colors that are not in the pattern
    @incorrects = []

    # correct colors in the wrong position
    @wrongs = Array.new(rules.rows, -1)

  end

  def get_guess

    last_guess = @board.last_guess
    eval_response = @board.evaluate_guess(last_guess)

    if eval_response == ""
      return random_answer(@rules)
    end

    0.upto(eval_response.length - 1) do |i|
      if eval_response[i] == Responses::CORRECT
        @corrects[i] = last_guess[i]

      elsif eval_response[i] == Responses::WRONG
        if @wrongs[i].kind_of?(Integer)
          @wrongs[i] = [last_guess[i]]
        else
          @wrongs[i].push(last_guess[i])
        end

      elsif not @incorrects.include?(last_guess[i])
        @incorrects.push(last_guess[i])
      end

    end

    new_guess = []
    0.upto(@rules.rows - 1) do |i|
      unless @corrects[i] == -1
        new_guess.push(@corrects[i])
        next
      end

      if @rules.repeats
        possible_colors = $colors_list - @incorrects
      elsif not @wrongs[i].kind_of?(Integer)
        possible_colors = ($colors_list - @wrongs[i]) - @incorrects
      else
        possible_colors = ($colors_list - new_guess) - @incorrects
      end

      new_guess.push(possible_colors[rand(possible_colors.length)])
    end

    new_guess

  end

end

def min(a, b)
  b < a ? b : a
end

def default(x, a)
  x == 0 ? a : x
end

print "How many rows do you want to play with? (max of 8) : "
rows = min(default(gets.chomp.to_i, 4), 8)

print "How many guesses do you want to play with? (max of 12) : "
guesses = min(default(gets.chomp.to_i, 12), 12)

print "Allow repeat colors? (y/n) : "
repeats = gets.chomp == 'y' ? true : false

print "Do you want to guess? (y/n) : "
guesser = gets.chomp == 'y' ? true : false

rules = Rules.new(rows, guesses, repeats)

# if player is guessing
if guesser
  correct_answer = random_answer(rules)
  puts "AI Generated An Answer..."
else
  correct_answer = get_guess(rules)
  puts "AI's Starting To Guess..."
end

board = Board.new(rules, guesser, correct_answer)
ai = AI.new(rules, board)

until board.is_game_over?
  # if player is guessing
  if guesser
    board.accept_guess
  else
    board.make_guess(ai.get_guess)
    print "Press Enter : "
    gets
  end

end