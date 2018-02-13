require "json"

class BattlesnakeAPI
  JSON.mapping(
    width: Int32,
    height: Int32,
    food: { type: PointList },
    you: { type: Snake }, 
    snakes: { type: SnakeList } 
  )
end

class PointList
  JSON.mapping(
    data: Array(Point)
  )
end

class Point
  JSON.mapping(
    x: Int32,
    y: Int32
  )
end

class SnakeList 
  JSON.mapping(
    data: Array(Snake)
  )
end

class Snake
  JSON.mapping(
    body: { type: PointList },
    health: Int32,
    id: String,
    length: Int32,
    name: String,
    taunt: String
  )
end
 
