require "./grid"

class World
  # Responsible for creating the world and returning a move direction

  def initialize(body : String)
    @grid = Grid.new(body)
  end

  def calculate
    "left"
  end
end
