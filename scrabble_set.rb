require_relative 'board.rb'

class ScrabbleSet
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
    puts @board.to_s
    
    # puts @board.to_s
    # @board.set_word([1,1], "east", "hat")
    # puts @board.to_s
    # @board.set_word([1,1], "east", "bla")
    # puts @board.to_s
  end

end

s = ScrabbleSet.new
s.play