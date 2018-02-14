class Grid

  FOOD = "food"
  SNAKE = "snake"
  SNAKE_HEAD = "snake_head"

  def initialize(body : String)
    @parser = BattlesnakeAPI.from_json(body)

    @grid = [] of Array(GridPoint)
    generate
  end

  def generate
    make_blank_grid()
    add_food_to_grid()
    add_snakes_to_grid()
    print
  end

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

      head = body.first
      @grid[head.x][head.y].content = SNAKE_HEAD
    end
  end
end

class GridPoint
  def initialize( content : String = "empty", content_id : Int32 = -1)
    @content = content
    @content_id = content_id
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
end
