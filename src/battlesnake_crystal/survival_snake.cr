class SurvivalSnake
  # Phase two: Once our snake is in a closed 
  # area, then try and to optimize space and
  # high five Guy Fieri on your way out

  UP    = {0,-1}
  DOWN  = {0, 1}
  LEFT  = {1, 0}
  RIGHT = {-1,0}

  def initialize(grid_obj : Grid)
    @grid_obj = grid_obj
  end

  def process
    collect_open_points  
  end

  # Returns GridPoints that can be moved into
  # from our snake's head
  #
  # @return [Array[GridPoint]]
  def collect_open_points 
    points = [] of GridPoint

    my_snake_head = @grid_obj.my_snake_head

    [LEFT, RIGHT, DOWN, UP].each do |dx_dy|
      x = my_snake_head.x + dx_dy[0]
      y = my_snake_head.y + dx_dy[1]

      if (@grid_obj.empty_point?(x, y))
        points << @grid_obj.grid[x][y]
      end
    end

    return points
  end

  # Checks the number of open spaces around a point

  # @params point [GridPoint]
  # @return [Int32]
  def num_open_edges(point)
    [LEFT, RIGHT, DOWN, UP].count do |dx_dy|
      x = point + dx_dy[0]
      y = point + dx_dy[1]

      @grid_obj.empty_point?(x, y)
    end
  end

end
