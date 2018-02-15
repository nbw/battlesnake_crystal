require "./grid"
require "./voronoi"

class World
  # Responsible for creating the world and returning a move direction

  def initialize(body : String)
    @grid = Grid.new(body)
  end

  def calculate
    vor = Voronoi.new(@grid)
    vor.process
    "left"
  end
end
