class Board
  def initialize(secret_code)
    @board_status = (Array.new(13, Turn.new))
  end
end

class Turn
  def initialize
    @is_clued = false
    @guess = Array.new(4)
    @clues = Array.new(4)
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