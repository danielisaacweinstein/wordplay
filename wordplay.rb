require_relative 'board.rb'

class WordPlay
  def initialize
    @board = Board.new
  end

  def to_s
    @board.to_s
  end

  def play
    @board.set_word([0,0], "south", "hello")
    @board.set_word([0,0], "east", "hello")
    @board.set_word([3,3], "east", "fgoa")

    @board.set_word([6,8], "east", "what")
    # @board.set_word([3,3], "east", "thisiswaytoolongwaaaaaaaytoooooolong")
    puts @board.to_s
  end

end

s = WordPlay.new
s.play