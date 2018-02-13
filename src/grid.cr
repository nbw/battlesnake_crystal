class Grid

  def initialize(body : String)
    @parser = BattlesnakeAPI.from_json(body)

    @grid = [] of Array(Int32)
    @grid = generate
  end

  def generate
    @grid = make_grid(@parser.width, @parser.height)
  end

  # Makes template grid filled with zeros
  #
  # @return Array[x][y]
  private def make_grid(width, height)
    Array.new(width, Array(Int32).new(height,0))
  end
end
