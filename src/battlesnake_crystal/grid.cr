class Grid

  EMPTY = "empty"
  FOOD = "food"
  SNAKE = "snake"
  SNAKE_HEAD = "snake_head"

  def initialize(body : String)
    @parser = BattlesnakeAPI.from_json(body)
    @grid = Array(GridPoint).new(width*height)

    generate
  end

  def get_point(x,y)
    @grid[x + y*width]
  end

  #  Generate a grid
  #  1. create a blank grid
  #  2. add food to the grid
  #  3. add snakes to the grid
  def generate
    make_blank_grid()
    add_food_to_grid()
    add_snakes_to_grid()
  end

  # Print the grid (used for dev purposes)
  def print
    return if @grid.empty?

    height.times do |y|
      str = String.build do |s|
        width.times do |x|
          case get_point(x,y).content 
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
    when (get_point(x,y).content == SNAKE), (get_point(x,y).content == SNAKE_HEAD) # check if snake
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
    @parser.you.body.first
  end

  def my_snake_index
    uniq_id = @parser.you.id
    index = snakes.index{|s| s.id == uniq_id}
    Int32.cast(index)
  end

  def snakes
    @parser.board.snakes
  end

  def width 
    @parser.board.width
  end

  def height 
    @parser.board.height
  end

  def food 
    @parser.board.food
  end

  def snakes 
    @parser.board.snakes
  end

  # # %%%%% END: Accessor methods %%%%%%


  # Makes template grid
  #
  # @return Array[x][y]
  private def make_blank_grid
    @grid = Array.new(width*height){
      GridPoint.new()
    }
    add_coords_to_grid()
  end

  private def add_coords_to_grid
    @grid.each_with_index do |points, index|
      x_index = index % width
      y_index = index / width 
      get_point(x_index,y_index).set_coord(x_index, y_index)
    end
  end

  private def add_food_to_grid
    food.each_with_index do |point, i|
      get_point(point.x,point.y).content = FOOD 
      get_point(point.x,point.y).content_id = i 
    end
  end
  
  private def add_snakes_to_grid
    snakes.each_with_index do |snake, i|
      # retrieve unique parts
      body = snake.body.uniq!{|p| {p.x, p.y}}

      body.each do |point|
        get_point(point.x,point.y).content = SNAKE
        get_point(point.x,point.y).content_id = i
      end

      # mark and record heads
      head = body.first
      get_point(head.x,head.y).content = SNAKE_HEAD
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
