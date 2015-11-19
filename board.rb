require_relative 'tile_space.rb'
require 'set'

class Board

  # Initialize @board_size x @board_size grid with TileSpace objects
  def initialize
    @board_size = 15
    @tile_grid = Array.new(@board_size) {
      Array.new(@board_size) { TileSpace.new(" ") }
    }
  end

  # Format and print either the board object by default, or another
  # board object if specified by the caller
  def to_s(grid = @tile_grid)
    grid_string = ""
    grid.each_with_index do |level_from_top, t_index|
      row_string = ""
      level_from_top.each_with_index do |keys_from_left, l_index|
        row_string << grid[l_index][t_index].to_s
      end
      grid_string << row_string + "\n\n"
    end
    grid_string
  end

  # Returns a deep copy of the Board on which the method is called
  # by creating a new grid of the same size and copying the contents
  # from each index to the new grid's TileSpace contents.
  def dup_grid
    grid_copy = Array.new(@board_size) {
      Array.new(@board_size) { TileSpace.new(" ") }
    }

    (0..@board_size - 1).each do |i|
      (0..@board_size - 1).each do |j|
        grid_copy[j][i].contents = @tile_grid[j][i].contents
      end
    end

    grid_copy
  end

  def is_valid_length?(starting_index, direction, word)
    starting_x, starting_y = starting_index[0], starting_index[1]
    is_valid = true

    if_valid = false if word.length < 2
    is_valid = false if direction == "east" and starting_index[0] + word.length > @board_size
    is_valid = false if direction == "south" and starting_index[1] + word.length > @board_size

    is_valid
  end

  def respects_board?(test_grid, starting_index, direction, word)
    starting_x, starting_y = starting_index[0], starting_index[1]
    is_valid = true

    word.split("").each_with_index do |letter, index|
      relative_tile = (direction == "east" ? test_grid[starting_x + index][starting_y] : test_grid[starting_x][starting_y + index])
      is_valid = false unless !relative_tile.nil? and (relative_tile.contents == " " or relative_tile.contents == letter)
    end

    is_valid
  end

  def all_valid_words?(test_grid, starting_index, direction, word)
    is_valid = true

    word.split("").each_with_index do |letter, i|
      set_tile(test_grid, [starting_index[0] + i, starting_index[1]], letter) if direction == "east"
      set_tile(test_grid, [starting_index[0], starting_index[1] + i], letter) if direction == "south"
    end

    row_list = []
    column_list = []

    (0..@board_size - 1).each do |i|
      row_string = ""
      column_string = ""
      (0..@board_size - 1).each do |j|
        row_string << test_grid[j][i].contents
        column_string << test_grid[i][j].contents
      end
      row_list << row_string
      column_list << column_string
    end

    words = []

    [row_list, column_list].each do |list|
      list.each do |line|
        line.split(" ").each do |cluster|
          words << cluster
        end
      end
    end

    words.reject! {|word| word.length < 2}
    
    dictionary = Set.new

    open('dictionary.txt') do |file|
      file.each_line {|line| dictionary << line.strip!}
    end

    words.each do |word|
      is_valid = false if !dictionary.include?(word)
    end

    is_valid
  end

  # Performs series of checks to test whether the move is valid
  def is_valid_move?(starting_index, direction, word)
    starting_x, starting_y = starting_index[0], starting_index[1]
    is_valid = true
    test_grid = dup_grid

    # Case statement?
    if !is_valid_length?(starting_index, direction, word)
      is_valid = false
    elsif !respects_board?(test_grid, starting_index, direction, word)
      is_valid = false
    elsif !all_valid_words?(test_grid, starting_index, direction, word)
      is_valid = false
    end

    return is_valid
  end

  def set_tile(grid, index, contents)
    row_index = index[0]
    column_index = index[1]
    grid[row_index][column_index].contents = contents
  end

  # TODO: Might make sense to rewrite so that I can specify the grid. That way, we can use the same method
  # for setting state on hypothetical boards as for the read board. It seems like we shouldn't _need_
  # to depend on @tile_grid specifically in the set_word method.
  def set_word(starting_index, direction, word)
    word = word.upcase

    if is_valid_move?(starting_index, direction, word)
      puts "VALID. starting_index: #{starting_index.to_s}, direction: #{direction}, word: #{word}."
      word.split("").each_with_index do |letter, i|
        set_tile(@tile_grid, [starting_index[0] + i, starting_index[1]], letter) if direction == "east"
        set_tile(@tile_grid, [starting_index[0], starting_index[1] + i], letter) if direction == "south"
      end
    else
      puts "INVALID. starting_index: #{starting_index.to_s}, direction: #{direction}, word: #{word}."
    end
  end
end
