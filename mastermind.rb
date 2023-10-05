class Board
  def initialize(secret_code)
    @board_status = Array.new(12, Turn.new)
  end

  def board_to_text
    top_border = '    --------------------●---○---'
    bottom_border = '    ----------------------------'
    row_seperator = '    -+---+---+---+---++---+---+-'
    turn_text = ->(turn, turn_number) { (turn_number + 1).to_s.rjust(3) + ' ' + turn.turn_to_text }
    top_border + "\n" + @board_status.each_with_index.map(&turn_text).join(row_seperator + "\n") + bottom_border
  end
end

class Turn
  def initialize
    @guess = Array.new(4)
    @clues = {
      correct_color: nil,
      correct_position: nil
    }
  end

  def turn_to_text
    side_border = '|| '
    col_seperator = ' | '
    guess = @guess.map { |guess_value| guess_value || ' ' }.join(col_seperator)
    clues = @clues.map { |_, clue_value| clue_value || ' ' }.join(col_seperator)
    side_border + [guess, clues, "\n"].join(' ' + side_border)
  end

  def input_guess(guess_values)
    @guess[0] = guess_values[0]
    @guess[1] = guess_values[1]
    @guess[2] = guess_values[2]
    @guess[3] = guess_values[0]
  end

  def get_clues(secret_code_values)
    pass
  end
end

class Player
  def initialize(name)
    @name = name
  end
end

class Game
  def initialize
    @board = Board.new
  end
end

puts Board.new(1234).board_to_text

#    --------------------●---○---
#  1 || 1 | 2 | 3 | 4 || 2 | 1 ||
#    -+---+---+---+---++---+---+-
#  2 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  3 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  4 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  5 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  6 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  7 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  8 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
#  9 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
# 10 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
# 11 ||   |   |   |   ||   |   ||
#    -+---+---+---+---++---+---++
# 12 ||   |   |   |   ||   |   ||
#    ----------------------------
