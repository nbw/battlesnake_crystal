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

  UP    = {0,-1}
  LEFT  = {-1,0}
  DOWN  = {0,1}
  RIGHT = {1,0}

  def initialize(grid_obj : Grid)
    @grid_obj    = grid_obj
    @cc_grid = [] of Array(ConnCompPoint)

    @label_count = 0
    @merge_ledger = [] of Array(Int32)

    make_blank_grid
  end

  def process
    # First pass
    first_pass
    second_pass
    merge
    puts adjacent_empty_areas(@grid_obj.my_snake_head).inspect
    print
  end

  # Returns the number of connected snakes 
  #
  # Look at the total areas of adjacent spots
  # and if there's an area that's big enough with
  # just you in it, take it.
  #
  # If there's one area:
  #  - false if another snake is in it
  #  - true if you're the only one

  def survival_mode?
    true
  end

  private def adjacent_empty_areas(point)
    empty_points = [] of ConnCompPoint    

    [LEFT, UP, DOWN, RIGHT].each do |dx_dy|
      x = point.x + dx_dy[0]
      y = point.y + dx_dy[1]
    
      if (empty_point?(x, y))
        empty_points << @cc_grid[x][y]
      end
    end

    empty_points
  end

  private def make_blank_grid
    grid.each do |row|
      cc_column = [] of ConnCompPoint

      row.each do |gp|
        cc_point = ConnCompPoint.new(gp) 
        cc_column << cc_point
      end
      @cc_grid << cc_column 
    end
  end

  # assign values to each square on the grid
  private def first_pass
    grid.each_with_index do |row, x| 
      row.each_with_index do |point, y|
        if point.snake?
          @cc_grid[x][y].value = 1
        end
      end
    end
  end

  # assign labels and do some analysis
  private def second_pass
    @cc_grid.each_with_index do |row, x| 
      row.each_with_index do |point, y|
        analyze_point(point)
      end
    end
  end

  # merges all the relations found in second_pass
  private def merge
    @merge_ledger.each do |relation|
      relation.sort!
      min = relation.shift
      relation.each do |r|
        @cc_grid.each do |row|
          row.select{|p| p.label == r}.each do |p|
            p.label = min
          end
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
    @cc_grid[x][y]
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
          point = @cc_grid[x][y]
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
