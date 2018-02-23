class VoronoiAnalyzer
  # Uses voronoi to minimize enemy snakes'
  # area.

  UP    = {0,-1}
  LEFT  = {-1,0}
  DOWN  = {0,1}
  RIGHT = {1,0}

  def initialize(v : Voronoi)
    @grid = v
  end

  def process
    paths = build_my_paths(degree: 2)
    ordered_paths = paths.sort_by do |path|
      fv = FutureVoronoi.new(grid: @grid.grid_obj, path: path)
      fv.process
      fv.tally_my_section
    end

    direction_to_path(ordered_paths.last)
  end

  def direction_to_path(path)
    point = path[1]
    head = @grid.my_voronoi_snake_head 

    if point.x > head.x
      "right"
    elsif point.x < head.x
      "left"
    elsif point.y > head.y
      "down"
    else
      "up"
    end
  end

  # Finds all possible paths on a voronoi grid starting at 
  # my snake head. Traverses recursively until no more paths
  # are available or reaches a point of value "degree"
  #
  # @return [] of Array(VoronoiPoint)
  def build_my_paths(degree, paths : Array(Array(VoronoiPoint)) = [[@grid.my_voronoi_snake_head]], count : Int32 = 0)
    if(count >= degree)
      return paths
    end

    new_paths = paths.flat_map do |path|
      path_head = path.last
      surr_points = surrounding_points(path_head, count + 1)

      surr_points.map do |new_point|
        p = path.dup
        new_point = new_point.dup
        new_point.owner_id = p.first.owner_id
        new_point.point.content_id = p.first.owner_id
        p << new_point
      end
    end 

    count += 1

    build_my_paths(degree: degree, paths: new_paths, count: count)
  end

  # Finds any surrounding points with @steps == value
  def surrounding_points(point, value)
    points = [] of VoronoiPoint

    [LEFT, UP, RIGHT, DOWN].each do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]
      if (@grid.empty_point?(x, y) && (@grid.vor_grid[x][y].steps == value))
        points << @grid.vor_grid[x][y]
      end
    end

    return points
  end
end
