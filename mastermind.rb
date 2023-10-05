class Board
  def initialize(secret_code)
    @board_status = Array.new(12, Turn.new)
    @secret_code_values = secret_code.split('')
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
    exact_position = 0
    same_color = 0

    [exact_position, same_color]
  end

  def compare_number_counts(secret_code_values)
    secret_code_number_count = secret_code_values.each_with_object(Hash.new(0)) { |value, number_count| number_count[value] += 1 }
    guess_number_count = @guess..each_with_object(Hash.new(0)) { |value, number_count| number_count[value] += 1 }
    [1..6].each { |number| secret_code_number_count[number] < guess_number_count[number] ? secret_code_number_count[number] : guess_number_count[number] }
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