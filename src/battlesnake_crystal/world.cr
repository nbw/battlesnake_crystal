# require "grid"

class World
  # Responsible for creating the world and returning a move direction

  def initialize(body : String)
    @grid = Grid.new(body)
  end

  def calculate
    if survival_mode?
      ss = SurvivalSnake.new(@grid)
      ss.process
    else
      vor = Voronoi.new(@grid)
      vor.process
      va = VoronoiAnalyzer.new(vor)
      va.process
    end
  end

  private def survival_mode?
    cc = ConnectedComponents.new(@grid)
    cc.process
    cc.survival_mode?
  end
end
