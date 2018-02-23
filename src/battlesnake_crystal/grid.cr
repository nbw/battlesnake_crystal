class Grid

  EMPTY = "empty"
  FOOD = "food"
  SNAKE = "snake"
  SNAKE_HEAD = "snake_head"

  def initialize(body : String)
    @parser = BattlesnakeAPI.from_json(body)
    @grid = [] of Array(GridPoint)

    generate
  end

  #  Generate a grid
  #  1. create a blank grid
  #  2. add food to the grid
  #  3. add snakes to the grid
  def generate
    make_blank_grid()
    add_food_to_grid()
    add_snakes_to_grid()
    # print
  end

  # Print the grid (used for dev purposes)
  def print
    return if @grid.empty?

    height.times do |y|
      str = String.build do |s|
        width.times do |x|
          case @grid[x][y].content 
          when SNAKE
            s << " ◦ ".colorize(:yellow)
          when SNAKE_HEAD
            s << " @ ".colorize(:yellow)
          when FOOD
            s << " ♥ ".colorize(:red)
          else
            s << " · "
          end
        end
      end
      puts str
    end
  end

  def empty_point?(x, y)
    case
    when (x < 0), (x > width-1) # check x bounds
      false
    when (y < 0), (y > height-1) # check y bounds
      false
    when (@grid[x][y].content == SNAKE), (@grid[x][y].content == SNAKE_HEAD) # check if snake
      false
    else
      true
    end
  end

  def snake_head?(point)
    point.snake_head?
  end

  def snake_body?(point)
    point.snake?
  end

  # %%%%% BEGIN: Accessor methods %%%%%%
  # Return the grid
  def grid
    @grid
  end

  def my_snake
    @parser.you
  end

  def my_snake_head
    @parser.you.body.data.first
  end

  def my_snake_index
    uniq_id = @parser.you.id
    index = snakes.index{|s| s.id == uniq_id}
    Int32.cast(index)
  end

  def snakes
    @parser.snakes.data
  end

  def width 
    @parser.width
  end

  def height 
    @parser.height
  end

  # # %%%%% END: Accessor methods %%%%%%


  # Makes template grid
  #
  # @return Array[x][y]
  private def make_blank_grid
    @grid = Array.new(width){
      Array(GridPoint).new(height){
        GridPoint.new()
      }
    }
    add_coords_to_grid()
  end

  private def add_coords_to_grid
    @grid.each_with_index do |row, x_index|
      row.each_with_index do |point, y_index|
        @grid[x_index][y_index].set_coord(x_index, y_index)
      end
    end
  end

  private def add_food_to_grid
    @parser.food.data.each_with_index do |point, i|
      @grid[point.x][point.y].content = FOOD 
      @grid[point.x][point.y].content_id = i 
    end
  end
  
  private def add_snakes_to_grid
    @parser.snakes.data.each_with_index do |snake, i|
      # retrieve unique parts
      body = snake.body.data.uniq!{|p| {p.x, p.y}}

      body.each do |point|
        @grid[point.x][point.y].content = SNAKE
        @grid[point.x][point.y].content_id = i
      end

      # mark and record heads
      head = body.first
      @grid[head.x][head.y].content = SNAKE_HEAD
    end
  end
end

class GridPoint
  property x : Int32
  property y : Int32
  property content : String
  property content_id : Int32

  def initialize(content : String = Grid::EMPTY, content_id : Int32 = -1)
    @content = content
    @content_id = content_id
    @x = 0
    @y = 0
  end

  def set_coord(x : Int32, y : Int32)
    @x = x
    @y = y
  end

  def empty?
    content == Grid::EMPTY
  end
  
  def food?
    content == Grid::FOOD
  end

  def snake?
    (content == Grid::SNAKE) || (content == Grid::SNAKE_HEAD)
  end

  def snake_head?
    content == Grid::SNAKE_HEAD
  end
end
