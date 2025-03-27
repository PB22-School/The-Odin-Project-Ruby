
dictionary = ["hello", "world", "quick", "brown", "fox", "jump", "jumps", "over", "the", "lazy", "dog"]

def substring(text, dictionary)

  split = text.split()

  out_dict = {}

  split.each do |word|
    dictionary.each do |dict_word|
      if word.include?(dict_word)

        amount = out_dict.dig(dict_word) ? out_dict.dig(dict_word): 0
        out_dict[dict_word] = amount + 1

      end
    end
  end

  out_dict

end

puts substring("Hello world brownfox", dictionary)