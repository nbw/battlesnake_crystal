class Grid

  FOOD = "food"
  SNAKE = "snake"
  SNAKE_HEAD = "snake_head"

  def initialize(body : String)
    @parser = BattlesnakeAPI.from_json(body)

    @grid = [] of Array(GridPoint)
    @snake_heads = [] of GridPoint

    generate
  end

  # Return the grid
  def grid
    @grid
  end

  # Return the snake_heads
  def grid
    @snake_heads
  end

  # Generate a grid
  # 1. create a blank grid
  # 2. add food to the grid
  # 3. add snakes to the grid
  def generate
    make_blank_grid()
    add_food_to_grid()
    add_snakes_to_grid()
    print
  end

  # Print the grid (used for dev purposes)
  def print
    return if @grid.empty?

    @parser.height.times do |y|
      str = String.build do |s|
        @parser.width.times do |x|
          case @grid[x][y].content 
          when SNAKE
            s << " ◦ "
          when SNAKE_HEAD
            s << " @ "
          when FOOD
            s << " ♥ "
          else
            s << " · "
          end
        end
      end
      puts str
    end
  end

  # Makes template grid filled with zeros
  #
  # @return Array[x][y]
  private def make_blank_grid
    @grid = Array.new(@parser.width){
      Array(GridPoint).new(@parser.height){
        GridPoint.new()
      }
    }
    add_coords_to_grid()
  end

  private def add_coords_to_grid
    @grid.each_with_index do |row, x_index|
      row.each_with_index do |column, y_index|
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
      @snake_heads.push(@grid[head.x][head.y])
    end
  end
end

class GridPoint
  def initialize(content : String = "empty", content_id : Int32 = -1)
    @content = content
    @content_id = content_id
    @x = 0
    @y = 0
  end

  def content
    @content
  end

  def content=(c : String)
    @content = c
  end

  def content_id
    @content_id
  end

  def content_id=( i : Int32)
    @content_id = i
  end

  def set_coord(x : Int32, y : Int32)
    @x = x
    @y = y
  end
end
