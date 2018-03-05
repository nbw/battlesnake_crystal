class ConnectedComponents
  # Connected components labeling
  #
  # @reference: https://en.wikipedia.org/wiki/Connected-component_labeling

  delegate width,        to: @grid_obj 
  delegate height,       to: @grid_obj 
  delegate empty_point?, to: @grid_obj 
  delegate snakes, to: @grid_obj 
  delegate grid, to: @grid_obj 
  delegate empty_point?, to: @grid_obj 

  UP    = { 0,-1}
  LEFT  = {-1, 0}
  DOWN  = { 0, 1}
  RIGHT = { 1, 0}
  DIRECTIONS = [LEFT, UP, RIGHT, DOWN]

  def initialize(grid_obj : Grid)
    @grid_obj    = grid_obj
    @cc_grid = Array(ConnCompPoint).new(width*height)

    @label_count = 0
    @merge_ledger = [] of Array(Int32)

    make_blank_grid
  end

  def get_point(x,y)
    @cc_grid[x + y*width]
  end

  def process
    # First pass
    first_pass
    second_pass
    merge
    # print
  end


  # Returns true if my_snake is it it's own area 
  #
  def survival_mode?
    # If solo game, always survival mode
    return true if (snakes.size <= 1)

    my_snake_adj_components = adjacent_empty_labels(@grid_obj.my_snake_head)

    # Snake should only belong to one area
    if (my_snake_adj_components.size <= 1)
      # If it does belong to one area,
      # check that there aren't any other snakes 

      # Grab all snakes, and remove my snake; remainder are enemy snakes
      enemy_snakes = snakes.dup 
      enemy_snakes.delete_at(@grid_obj.my_snake_index)

      # Collect adj components of all enemy snake heads
      enemy_components = enemy_snakes.flat_map do |snake|
        head = snake.body.data.first
        adjacent_empty_labels(head)
      end.uniq

      # The component my snake occupies
      my_area = my_snake_adj_components.first

      # Do components occupied by enemy snakes NOT include my
      # snake?
      !enemy_components.includes?(my_area)
    else
      false
    end

  end

  private def adjacent_empty_labels(point)
    empty_points = [] of ConnCompPoint    

    DIRECTIONS.each do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]

      if (empty_point?(x, y))
        empty_points << get_point(x,y)
      end
    end

    empty_points.map{|p| p.label}.uniq
  end

  private def make_blank_grid
    grid.each do |gp|
      cc_point = ConnCompPoint.new(gp) 
      @cc_grid << cc_point 
    end
  end

  # assign values to each square on the grid
  private def first_pass
    grid.each_with_index do |point, index| 
      if point.snake?
        @cc_grid[index].value = 1
      end
    end
  end

  # assign labels and do some analysis
  private def second_pass
    @cc_grid.each do |point| 
      analyze_point(point)
    end
  end

  # merges all the relations found in second_pass
  private def merge
    @merge_ledger.each do |relation|
      relation.sort!
      min = relation.shift
      relation.each do |r|
        @cc_grid.select{|p| p.label == r}.each do |p|
          p.label = min
        end
      end
    end
  end

  private def one_dir_check(point, dir)
    side_point = point_at(point, dir) 

    if (side_point.value == point.value)
      point.label = side_point.label
    else
      @label_count += 1
      point.label = @label_count
    end
  end

  # https://en.wikipedia.org/wiki/Connected-component_labeling#Two-pass
  private def two_dir_check(point)
    left  = point_at(point, LEFT) 
    up    = point_at(point, UP) 

    if ((left.value == point.value) &&
        (up.value   == point.value) &&
        (up.label   != left.label))

      @merge_ledger << [left.label, up.label]
      point.label = [left.label, up.label].min

    elsif (left.value == point.value)
      point.label = left.label

    elsif ((left.value != point.value) &&
           (up.value   == point.value))
      point.label = up.label

    elsif ((left.value != point.value) &&
           (up.value   != point.value))
      @label_count += 1
      point.label = @label_count
    end
  end

  private def analyze_point(point)
    top_row?      = (point.y == 0)
    first_column? = (point.x == 0)

    # if top row
    if (top_row?)
      one_dir_check(point, LEFT)

      # if first column
    elsif (first_column?)
      one_dir_check(point, UP)

      # normal case
    else
      two_dir_check(point)
    end

  end

  private def point_at(p, dir)
    x = p.x + dir[0]  
    y = p.y + dir[1]  
    get_point(x,y)
  end


  def print
    return if @cc_grid.empty?

    colors = [
      :light_magenta,
      :magenta,
      :cyan,
      :green,
      :red,
      :yellow,
      :blue
    ]

    height.times do |y|
      str = String.build do |s|
        width.times do |x|
          point = get_point(x,y)
          val = point.label

          color = colors[(val % colors.size)]

          if val < 10
            s << "  #{val}  ".colorize(color)
          else
            s << " #{val}  ".colorize(color)
          end
        end
      end
      puts str
    end
  end
end

# Connected Component Point
class ConnCompPoint
  delegate x, to: @gp 
  delegate y, to: @gp 

  property value : Int32
  property label : Int32

  def initialize(gp : GridPoint)
    @label = 0
    @value = 0
    @gp = gp
  end

end
