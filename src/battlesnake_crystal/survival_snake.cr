class SurvivalSnake
  # Phase two: Once our snake is in a closed 
  # area, then try and to optimize space and
  # high five Guy Fieri on your way out

  UP    = {0,-1}
  DOWN  = {0, 1}
  LEFT  = {-1,0}
  RIGHT  = {1, 0}
  DIRECTIONS = [LEFT, UP, RIGHT, DOWN]

  delegate my_snake_head, to: @grid_obj 

  def initialize(grid_obj : Grid)
    @grid_obj = grid_obj
  end

  def process
    open_dir = collect_open_directions  

    # find a point with the least open spaces (or more edges)
    min_edges = open_dir.min_of?{|d| num_open_edges(d)}

    # find candidate directions based on the min
    candidate_dirs = open_dir.select{|d| num_open_edges(d) == min_edges}

    # in a specific order, check if candidate is available
    case
    when candidate_dirs.includes?(LEFT)
      "left"
    when candidate_dirs.includes?(UP)
      "up"
    when candidate_dirs.includes?(RIGHT)
      "right"
    when candidate_dirs.includes?(DOWN)
      "down"
    else
      puts "[SurvivalSnake]: No candidates!"
      "left"
    end
  end

  # Returns GridPoints that can be moved into
  # from our snake's head
  #
  # @return [Array[String]]
  def collect_open_directions 
    directions = [] of Tuple(Int32, Int32)

    DIRECTIONS.each do |dx_dy|
      x = my_snake_head.x + dx_dy[0]
      y = my_snake_head.y + dx_dy[1]

      if (@grid_obj.empty_point?(x,y))
        directions << dx_dy
      end
    end

    return directions
  end

  # Returns the number of open spaces around a point
  #
  # @params dir [Tuple(Int32, Int32)]
  # @return [Int32]
  def num_open_edges(dir)
    x = my_snake_head.x + dir[0]
    y = my_snake_head.y + dir[1]
    point = @grid_obj.get_point(x,y)

    DIRECTIONS.count do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]

      @grid_obj.empty_point?(x,y)
    end
  end

end
