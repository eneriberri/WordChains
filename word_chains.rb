require 'Set'
class WordChain
  attr_reader :dictionary, :current_words, :visited_words

  def initialize()
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @current_words = []
    @visited_words = {}
  end

  def adjacent_words(word)
    narrow_dictionary(word)

    word_array = word.split('')
    adj_words = []
    dictionary.each do |dict_word|
      dict_word_array = dict_word.split('')
      if word_similar(word,dict_word)
        adj_words << dict_word_array.join
      end
    end
    adj_words
  end

  def narrow_dictionary(word)
    dictionary.select! do |dict_word|
      dict_word.length == word.length
    end
  end

  def word_similar(word,dict_word)
    diff = 0
    word.each_char.with_index do |letter, index|
      if letter != dict_word[index]
        diff += 1
      end
    end
    diff == 1
  end

  def find_chain(start_word, end_word)
    current_words << start_word
    visited_words[start_word] = nil
    while !current_words.empty?
      the_word = current_words.shift
      #puts "the word is #{the_word}"
      new_words = adjacent_words(the_word)
      new_words.each do |word|
        if !visited_words.include?(word) && !current_words.include?(word)
          current_words << word
          visited_words[word] = the_word
          if word == end_word
            return build_chain(end_word)
          end
        end
      end
    end
  end

  def build_chain(end_word)
    puts "hello"
    chain = [end_word]
    next_word = visited_words[end_word]
    while next_word
      chain << visited_words[next_word]
      next_word = visited_words[next_word]
    end
    chain.reverse!
  end

end


chain = WordChain.new
#p chain.adjacent_words("duck")
#puts chain.find_chain("hi", "an")
puts chain.find_chain("duck", "ruby")
