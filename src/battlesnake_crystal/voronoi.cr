require "./grid"

class Voronoi
  # Implementation of the Voronoi Heuristic

  delegate width,        to: @grid_obj
  delegate height,       to: @grid_obj
  delegate empty_point?, to: @grid_obj
  delegate snake_head?,  to: @grid_obj
  delegate snake_body?,  to: @grid_obj

  getter vor_grid : Array(VoronoiPoint)
  getter grid_obj : Grid
  getter sections : Hash(Int32, Int32)

  UP    = { 0,-1}
  LEFT  = {-1, 0}
  DOWN  = { 0, 1}
  RIGHT = { 1, 0}
  DIRECTIONS = [LEFT, UP, RIGHT, DOWN]

  def initialize(grid : Grid)
    @grid_obj    = grid
    @vor_grid    = Array(VoronoiPoint).new(width*height)
    @snake_heads = Array(VoronoiPoint).new
    @sections = Hash(Int32, Int32).new
  end

  def get_point(x,y)
    @vor_grid[x + y*width]
  end

  def process
    make_grid()
    flood_grid()
  end

  def tally_my_section
    area_of_owner(@grid_obj.my_snake_index)
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

          point = get_point(x,y)

          case
          when snake_head?(point.point)
            s << "  @  ".colorize(:yellow)
          when snake_body?(point.point)
            s << "  ◦  ".colorize(:yellow)
          else
            owner = point.owner_id
            step = point.steps

            if(point.intersection)
              color = :white
            elsif owner < 0
              color = :black
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

  def my_voronoi_snake_head
    head = @grid_obj.my_snake_head
    get_point(head.x,head.y)
  end

  # Looks for points with a step value
  # and explores their neighbour points
  private def flood_grid(step : Int32 = 0, points : Array(VoronoiPoint) = @snake_heads)
    # if there are no more unvisited neightbouring points, stop
    return unless points.any?{ |p| has_unvisited_neighbours?(p)}

    new_points = points.flat_map do |p|
      flood_point(p)
    end

    flood_grid(step+1, new_points)
  end

  # Check spaces around point and mark
  # them if valid
  private def flood_point(point : VoronoiPoint)
    new_points = [] of VoronoiPoint

    DIRECTIONS.each do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]

      if (empty_point?(x,y))
        possible_point = get_point(x,y)
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
          possible_point.owner_id = VoronoiPoint::INTERSECTION

          # else if the point hasn't been visted, mark it
        elsif(!possible_point.visited?)
          get_point(x,y).mark_visited!(new_step_val, point.owner_id)
          new_points << possible_point
        end
      end
    end

    new_points
  end


  # Checks if point has any unvisited neighbour points
  private def has_unvisited_neighbours?(point)
    res = DIRECTIONS.map do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]

      empty_point?(x,y) && get_point(x,y).unvisited?
    end

    res.any?()
  end


  # Makes template grid
  #
  # @return Array[x][y]
  private def make_grid
    grid = @grid_obj.grid

    grid.each do |gp|
      vol_point = VoronoiPoint.new(gp: gp)

      # keep track of snake heads
      if (snake_head?(gp))
        vol_point.owner_id = gp.content_id
        @snake_heads << vol_point
      end

      @vor_grid <<  vol_point
    end
  end

  # returns the number of points belonging
  # to an owner_id
  private def area_of_owner(owner_id)
    owners_points = @vor_grid.select{|point| point.owner_id == owner_id}
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
  property point : GridPoint
  getter steps : Int32

  VISITED = "visited"
  INTERSECTION = -1
  NOT_OWNED = -2

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
      NOT_OWNED
    end
  end

end

