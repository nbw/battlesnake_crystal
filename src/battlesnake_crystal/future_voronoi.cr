require "../battlesnake_crystal/voronoi"

class FutureVoronoi < Voronoi
  delegate my_snake_index, to: @grid_obj

  def initialize(grid : Grid, path : Array(VoronoiPoint))
    @path = [] of VoronoiPoint 
    @path = path

    super(grid)
  end

  def empty_point?(x, y)
    if(is_path_point?(x, y))
      false
    else
      super(x, y)
    end
  end

  def my_vornoi_snake_head
    @path.last
  end

  def snake_head?(point : GridPoint)
    # if my snake, use @path
    head = @path.last

    if(point.content_id == my_snake_index) 
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
    points = @path.map{|p| {p.x, p.y}}
    points.includes?({x,y})
  end
end
