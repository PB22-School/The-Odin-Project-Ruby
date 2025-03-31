
def caesar_cypher(text, shift = 13)

  abcs = ('a'..'z').to_a
  splitted = text.split('')

  out_text = ""

  for char in splitted
    unless abcs.include?(char.downcase)
      out_text += char
      next
    end

    capital = char == char.upcase

    next_char = abcs[((abcs.find_index(char.downcase) + shift) % 26)]

    if capital
      out_text += next_char.upcase
    else
      out_text += next_char
    end
  end

  out_text

end

def caesar_cypher!(text, shift = 13)

  abcs = ('a'..'z').to_a

  0.upto(text.length - 1) do |i|

    char = text[i].downcase

    unless abcs.include?(char)
      next
    end
    
    capital = text[i] == text[i].upcase

    text[i] = abcs[((abcs.find_index(char) + shift) % 26)]

    if capital
      text[i] = text[i].upcase
    end
  end

  text

end

if __FILE__ == $0

  loop do
    print "Something to Encode: "
    str = gets.chomp

    caesar_cypher!(str)
    puts str
  end
  
end