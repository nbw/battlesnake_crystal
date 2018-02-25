require "../battlesnake_crystal/voronoi"
require "../battlesnake_crystal/grid"

class FutureVoronoi < Voronoi
  delegate my_snake_index, to: @grid_obj

  def initialize(grid : Grid, path : Array(VoronoiPoint))
    @path = [] of VoronoiPoint 
    @path = path
    @path_points = [] of Tuple(Int32,Int32)
    @path_points = @path.map{|p| {p.x, p.y}}
    super(grid)
  end

  # empty point and not a path point
  def empty_point?(x, y)
    !is_path_point?(x, y) && super(x, y)
  end

  def my_vornoi_snake_head
    @path.last
  end

  def snake_head?(point : GridPoint)
    if(point.content_id == my_snake_index) 
      # if my snake, use @path
      head = @path.last

      (head.x == point.x) && (head.y == point.y)
    else
      super(point)
    end
  end
  
  def snake_body?(point : GridPoint)
    # if my snake, use @path
    if(point.content_id == my_snake_index) 
      is_path_point?(point.x, point.y) || super(point)  
    else
      super(point)
    end
  end

  # checks if NOT a path point && empty? or food?
  def available_point?(point : VoronoiPoint)
    !is_path_point?(point.x, point.y) && super(point)
  end

  def is_path_point?(x : Int32, y : Int32)
    @path_points.includes?({x, y})
  end
end
