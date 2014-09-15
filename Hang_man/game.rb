require './player.rb'
class Game
  attr_accessor :mode, :words, :secret_word, :guessed_letters, :picker, :guesser

  def initialize(guesser, picker = ComputerPlayer.new('default'))
    @guessed_letters = [' ']
    @picker = picker
    @guesser = guesser
  end

  def play
    self.picker.pick_word_length

    until won?
      prompt
      guess(self.guesser.get_input(self.guessed_letters, word_status))
    end

    prompt
    puts "#{self.guesser.name} won!"
  end

  def prompt
    print "secret word: "
    print word_render
    print "\n> "
  end

  def guess(new_letter)
    unless self.guessed_letters.include?(new_letter[0])
      self.guessed_letters << new_letter[0]
    end

    self.picker.update_word(new_letter)
  end

  def won?
    return false if self.word_status.include?(nil)
    true
  end

  def word_status
    self.picker.word_status(self.guessed_letters)
  end

  def word_render
    self.picker.word_render# (self.guessed_letters)
  end
end

