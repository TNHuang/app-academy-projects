class Player
  attr_accessor :name
  def get_input
  end
  def update_word(new_letter)
  end
end

class HumanPlayer < Player
  def initialize(name)
    self.name = name

  end

  def get_input(guessed_letters, status)
    gets.chomp
  end

  def pick_word_length
    puts "How long is your word?"
    print "> "
    length = Integer(gets.chomp)
    self.word_so_far = Array.new(length)
    length
  end

  def word_status(guessed_letters)
    self.word_so_far
  end

  def update_word(new_letter)
    puts "Where is #{new_letter} in your word?"
    print "> "
    indices = gets.chomp.split(', ').map{ |index| Integer(index) }
    indices.each do |index|
      if index < word_so_far.length && word_so_far[index].nil?
        self.word_so_far[index] = new_letter
      end
    end
  end

  def word_render
    as_a_string = ''
    word_so_far.each do |letter|
      as_a_string << ( letter || '_' )
    end
    as_a_string
  end

  protected
  attr_accessor :word_so_far
end

class ComputerPlayer < Player

  def initialize(name,dict_file_name = 'dictionary.txt')
    self.name = name
    @dictionary= File.readlines(dict_file_name).map(&:chomp)
    self.available_words = @dictionary.clone
    self.reguessing = false
  end

  def get_input(guessed_letters, status)
    remaining_letters = ('a'..'z').to_a - guessed_letters
    unless remaining_letters.empty?
      input = ai_guess(guessed_letters, status)
    else
      unless self.reguessing
        puts "#{name} says: You cheated. I'm reguessing letters."
        self.reguessing = true
      end
      input = ('a'..'z').to_a.sample
    end

    puts "#{name} guessed #{input}."
    input
  end

  def ai_guess(guessed_letters, word_status)
    words_filter(word_status)
    letters_union = self.available_words.join.split(//)
    letters_union -= guessed_letters

    max_count = 0
    max_letter = nil
    ('a'..'z').each do |letter|
      letter_count = letters_union.count(letter)
      if letter_count > max_count
        max_letter = letter
        max_count = letter_count
      end
    end

    max_letter
  end

  def pick_word_length
    pick_word.length
  end

  def pick_word
    self.secret_word = @dictionary.sample.to_a
  end

  def word_status(guessed_letters)
    self.secret_word.map do |letter|
      guessed_letters.include?(letter) ? letter : nil
    end
  end

  def word_render
    self.secret_word.join[0].gsub(/[^#{guessed_letters.join}]/, '_')
  end

  protected
  attr_accessor :secret_word, :reguessing, :available_words

  private

  def words_filter(word_status)
    available_words.delete_if {|word| word.length != word_status.length}
    word_status.each_with_index do |letter, index|
      unless letter.nil?
        available_words.delete_if {|word| word[index] != letter}
      end
    end
  end

end