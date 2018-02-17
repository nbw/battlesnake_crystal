# require "grid"

class World
  # Responsible for creating the world and returning a move direction

  def initialize(body : String)
    @grid = Grid.new(body)
  end

  def calculate
    # vor = Voronoi.new(@grid)
    # vor.process
    # ss = SurvivalSnake.new(@grid)
    # puts ss.process.inspect
    "left"
  end
end
