class Voronoi
  # Implementation of the Voronoi Heuristic

  delegate width,        to: @grid_obj 
  delegate height,       to: @grid_obj 
  delegate empty_point?, to: @grid_obj 

  def initialize(grid : Grid)
    @grid_obj    = grid
    @vor_grid    = [] of Array(VoronoiPoint)
    @snake_heads = [] of VoronoiPoint
    @sections = Hash(Int32, Int32).new
  end

  def process
    make_grid()
    flood_grid()
    calculate_sections()
    print
  end

  def calculate_sections
    @snake_heads.each do |snake|
      owner_id = snake.owner_id
      @sections[owner_id] = area_of_owner(owner_id)
    end

    # record area of intersection points
    @sections[-1] = area_of_owner(-1)
  end

  # Looks for points with a step value
  # and explores their neightbour points
  def flood_grid(step : Int32 = 0)
    if (step == 0) 
      points = @snake_heads
    else
      # Select points with a certain steps value that
      # are empty or food. 
      points = @vor_grid.flat_map do |row| 
        row.select{ |point|
          (point.steps == step) && (point.empty? || point.food?) && !point.intersection
        }
      end
    end

    points.each do |p|
      flood_point(p)
    end

    if (are_there_unvisited_points?)
      flood_grid(step+1)
    end
  end

  # Check spaces around point and mark
  # them if valid
  def flood_point(point : VoronoiPoint)
    [{1,0}, {-1,0}, {0,1}, {0,-1}].each do |dx_dy|
      dx = dx_dy[0]
      dy = dx_dy[1]
      x = point.x + dx
      y = point.y + dy

      if (empty_point?(x, y))
        possible_point = @vor_grid[x][y]
        new_step_val = point.steps + 1

        # if the point has been:
        # 1. visited already
        # 2. visited by a different owner
        # 3. has the same value 
        if ( possible_point.visited? &&
            (possible_point.owner_id != point.owner_id) &&
            (possible_point.steps == new_step_val)
          )
          possible_point.intersection = true
          possible_point.owner_id = -1
          
        # else if the point hasn't been visted, mark it
        elsif(!possible_point.visited?)
          @vor_grid[x][y].mark_visited!(new_step_val, point.owner_id)
        end
      end

    end
  end

  # Print the grid (used for dev purposes)
  def print
    return if @vor_grid.empty?

    colors = [
      :light_magenta,
      :blue,
      :magenta,
      :cyan,
      :green,
      :red
    ]

    height.times do |y|
      str = String.build do |s|
        width.times do |x|

          point = @vor_grid[x][y]
          
          case point.content 
          when Grid::SNAKE
            s << "  ◦  ".colorize(:yellow)
          when Grid::SNAKE_HEAD
            s << "  @  ".colorize(:yellow)
          else
            owner = point.owner_id
            step = point.steps

            if(point.intersection)
              color = :white
            else
              color = colors[(owner % colors.size)]
            end

            if step < 10
              s << "  #{step}  ".colorize(color)
            else
              s << " #{step}  ".colorize(color)
            end
          end
        end
      end
      puts str
    end
  end

  # checks if the grid still has unvisited "empty" points
  private def are_there_unvisited_points?
      unvisited_points = @vor_grid.flat_map do |row| 
        row.select{ |point|
          point.unvisited? && (point.empty? || point.food?)
        }
      end

      (unvisited_points.size > 0)
  end

  # Makes template grid
  #
  # @return Array[x][y]
  private def make_grid
    grid = @grid_obj.grid 

    grid.each do |row|
      vol_column = [] of VoronoiPoint

      row.each do |gp|
        vol_point = VoronoiPoint.new(gp: gp) 

        # keep track of snake heads
        if (gp.content == Grid::SNAKE_HEAD)
          vol_point.owner_id = gp.content_id
          @snake_heads << vol_point
        end

        vol_column << vol_point
      end
      @vor_grid << vol_column 
    end
  end

  # returns the number of points belonging
  # to an owner_id
  private def area_of_owner(owner_id)
      owners_points = @vor_grid.flat_map do |row| 
        row.select{|point| point.owner_id == owner_id}
      end

      owners_points.size
  end
end


class VoronoiPoint
  delegate x, to: @point 
  delegate y, to: @point 
  delegate content, to: @point 
  delegate content_id, to: @point 
  delegate empty?, to: @point 
  delegate food?, to: @point 

  property owner_id : Int32
  property intersection : Bool
  getter steps : Int32

  VISITED = "visited"

  def initialize(gp : GridPoint, status : String = "")
    @point = gp
    @status = status
    @steps  = 0
    @intersection  = false
    @owner_id  = determine_owner
  end

  def mark_visited!(steps, owner_id)
    @status = VISITED
    @owner_id = owner_id
    @steps = steps
  end

  def visited?
    @status == VISITED
  end

  def unvisited?
    @status != VISITED
  end

  private def determine_owner
    content_id = @point.content_id
    if (content_id >= 0)
      content_id
    else
      -1
    end
  end

end

