require 'set'

class WordChainer
  attr_accessor :dictionary

  def initialize(filename = 'dictionary.txt')
    self.dictionary = File.readlines(filename).map(&:chomp)
    self.dictionary = Set.new(self.dictionary)
  end

  def adjacent_words(word)
    result = []
    
    word.split('').each_with_index do |pre_letter, index|
      (('a'..'z').to_a-[pre_letter]).each do |post_letter|
        new_word = word.dup
        new_word[index] = post_letter

        result << new_word if dictionary.include?(new_word) 
      end
    end

    result
  end

  def run(source, target)
    # word_length = source.length
    # self.dictionary = self.dictionary.select {|word| word.length == word_length}

    @current_words = [source]
    @all_seen_words = {source => nil}

    until @current_words.empty? || @all_seen_words.include?(target)
      explore_current_words
    end

    build_path(target)
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|  
        unless @all_seen_words.has_key?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words[adjacent_word] = current_word
        end
      end

    end
    # @current_words.each do |word|
    #   print "#{word} => #{@all_seen_words[word]}\n"
    # end
    @current_words = new_current_words
  end

  def build_path(target)
    path = []
    current_word = target
    until current_word.nil?
      path.unshift(current_word)
      current_word = @all_seen_words[current_word]
    end

    path
  end
end

k = WordChainer.new('dictionary.txt')
# puts k.adjacent_words('apple')
puts k.run('power', 'house')
# @current_word = [:market]
# @all_seen_words = {:market => nil}
# k.explore_current_words

# @current_words.each do |word|
#   puts "#{word} =>#{@all_seen_words[word] }"
# end