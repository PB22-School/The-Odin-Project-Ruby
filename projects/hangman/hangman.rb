
require "../caesar-cypher.rb"
require "yaml"

WORDLIST = "google-10000-english-no-swears.txt"

def save_file(save_n)
  return "save_" + save_n.to_s + ".sv"
end

class Save
  def initialize(secret_word, letters, health)
    @secret_word = secret_word
    @letters = letters
    @health = health
  end

  def secret_word
    caesar_cypher(@secret_word)
  end

  def letters
    @letters
  end

  def health
    @health
  end

end

class Game
  def initialize

    @letters = ""
    @health = 5
    
    File.open(WORDLIST, "r") do |f|

      f.pos = rand(5000)
      f.gets

      @secret_word = f.gets.chomp

      until @secret_word.length >= 5 and @secret_word.length <= 12
        @secret_word = f.gets.chomp
      end

      f.close
    end

  end

  def save
    serialized = YAML::dump(Save.new(caesar_cypher(@secret_word), @letters, @health))

    start = 1

    while File.exists?(save_file(start))
      start += 1
    end

    f = File.open(save_file(start), "w")
    f.puts serialized
    f.close
  end

  def turn

    loop do
      print "Put a letter, or 'SAVE' to save : "
      input = gets.chomp.upcase

      if input == "SAVE"
        save
        print "Game Saved!"
        return
      end

      if @letters.include?(input)
        puts "You Already Used That Letter."
      elsif input.length != 1
        puts "Only Insert ONE letter, or 'SAVE'."
      else
        @letters += input

        unless @secret_word.include?(input.downcase)
          @health -= 1
        end

        return
      end

    end

  end

  def print_game

    puts 

    #     01234567
    puts "  ------"
    puts "  |    |"

    if @health != 5
      #     01234567
      puts "  |    O"
    else
      puts "  |     "
    end

    if @health < 3
      #     01234567
      puts "  |  --|--"
    elsif @health < 4
      puts "  |  --|"
    else
      puts "  |     "
    end

    if @health < 1
      #     01234567
      puts "  |   / \\"
    elsif @health < 2
      puts "  |   /  "
    else
      puts "  |    "
    end

    #     01234567
    puts " ---"

    puts

    0.upto(@secret_word.length - 1) do |i|

      unless @letters.include?(@secret_word[i].upcase)
        print " _ "
      else
        print " " + @secret_word[i] + " "
      end
    end

    puts
    puts

    puts " Used Letters: "

    puts

    0.upto(@letters.length - 1) do |i|
      print " " + @letters[i] + " "
    end

    puts
    puts
  end

  def is_game_over?

    if @health <= 0
      puts "You Ran Out Of Health!"
      puts "The Word Was : #{@secret_word}!!!"
      return true
    end

    0.upto(@secret_word.length - 1) do |i|
      unless @letters.include?(@secret_word[i])
        return false
      end
    end

    puts "You Guessed The Word!!"
    return true

  end

  def load_game(save_num)

    serialized = File.read(save_file(save_num))

    save_obj = YAML::load(serialized)

    puts save_obj

    @secret_word = save_obj.secret_word
    @letters = save_obj.letters
    @health = save_obj.health

  end


end

game = Game.new

print "\nLoad A Save? (# or enter) : "
num = gets.chomp.to_i

if File.exists?(save_file(num))
  game.load_game(num)
end

until game.is_game_over?
  game.print_game
  game.turn
end

game.print_game