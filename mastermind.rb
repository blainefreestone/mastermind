require 'pry-byebug'

class Board
  def initialize(secret_code)
    @board_status = Array.new(12, Turn.new)
    @secret_code_values = secret_code.to_s.split('')
  end

  def board_to_text
    top_border = '    --------------------●---○---'
    bottom_border = '    ----------------------------'
    row_seperator = '    -+---+---+---+---++---+---+-'
    turn_text = ->(turn, turn_number) { (turn_number + 1).to_s.rjust(3) + ' ' + turn.turn_to_text }
    top_border + "\n" + @board_status.each_with_index.map(&turn_text).join(row_seperator + "\n") + bottom_border
  end

  def count_test
    @board_status[1].input_guess([1, 2, 3, 4])
    @board_status[1].get_clues([4, 3, 2, 1])
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
    @guess[3] = guess_values[3]
  end

  def get_clues(secret_code_values)
    get_same_color_count(secret_code_values)
  end

  def get_same_color_count(secret_code_values)
    secret_code_number_count = code_number_count(secret_code_values)

    secret_code_number_count.reduce(0) do |count, key, value|
      greater_value = guess_number_count[key] > value ? value : guess_number_count[key]
      count += greater_value
      count
    end
  end

  def code_number_count(secret_code_values)
    secret_code_values.each_with_object(Hash.new(0)) do |value, number_count|
      number_count[value] += 1
    end
  end

  def guess_number_count
    @guess.each_with_object(Hash.new(0)) do |value, number_count|
      number_count[value] += 1
    end
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

board = Board.new(1234)
board.count_test
