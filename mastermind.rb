class Board
  def initialize(secret_code)
    @board_status = Array.new(12) { Turn.new }
    @secret_code_values = secret_code
  end

  def board_to_text
    top_border = '    --------------------○---●---'
    bottom_border = '    ----------------------------'
    row_seperator = '    -+---+---+---+---++---+---+-'
    turn_text = ->(turn, turn_number) { (turn_number + 1).to_s.rjust(3) + ' ' + turn.turn_to_text }
    top_border + "\n" + @board_status.each_with_index.map(&turn_text).join(row_seperator + "\n") + bottom_border
  end

  def update_turn(turn_number, guess_values)
    @board_status[turn_number].input_guess(guess_values)
    @board_status[turn_number].update_clues(@secret_code_values)
    @board_status[turn_number].marked_correct?
  end
end

class Turn
  def initialize
    @guess = Array.new(4)
    @clues = {
      correct_value: nil,
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

  def update_clues(secret_code_values)
    same_position_count = @guess.each_with_index.reduce(0) do |count, (value, index)|
      count += 1 if value == secret_code_values[index]
      count
    end

    @clues[:correct_value] = same_value_count(secret_code_values) - same_position_count
    @clues[:correct_position] = same_position_count
  end

  def marked_correct?
    @clues[:correct_position] == 4
  end

  private

  def same_value_count(secret_code_values)
    secret_code_number_count(secret_code_values).reduce(0) do |count, (key, value)|
      count += guess_number_count[key] > value ? value : guess_number_count[key]
      count
    end
  end

  def secret_code_number_count(secret_code_values)
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

  def guess_code
    puts "#{@name}, please enter a 4 digit code (numbers 1-6):"
    return_guess_values = []
    Kernel.loop do
      player_guess_values = gets.strip.split('').map(&:to_i)
      is_valid_integer = ->(value) { value.to_i && value >= 1 && value <= 6 }
      return_guess_values = player_guess_values
      break if player_guess_values.all?(&is_valid_integer) && player_guess_values.length == 4

      puts 'That is not a valid guess.'
    end
    return_guess_values
  end
end

class Game
  def initialize(code_maker, decoder)
    @board = Board.new([1, 2, 3, 4])
    @code_maker = code_maker
    @decoder = decoder
  end

  def play
    decoded = false
    (0..11).each do |turn_number|
      system 'clear'
      puts @board.board_to_text
      decoded = @board.update_turn(turn_number, @decoder.guess_code)
      break if decoded
    end
    system 'clear'
    puts decoded ? 'The code was successfully decoded' : 'The code was not decoded'
    puts @board.board_to_text
  end
end

player1 = Player.new('Blaine')
player2 = Player.new('Destiny')

game = Game.new(player1, player2)
game.play
