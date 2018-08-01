require "json"

class BattlesnakeAPI
  JSON.mapping(
    board: {type: Board},
    you: {type: Snake}
  )
end

class Board
  JSON.mapping(
    width: Int32,
    height: Int32,
    food: Array(Point),
    snakes: Array(Snake)
  )
end

class Point
  JSON.mapping(
    x: Int32,
    y: Int32
  )
end

class Snake
  JSON.mapping(
    body: Array(Point),
    health: Int32,
    id: String,
    name: String,
    taunt: {type: String, nilable: true}
  )
end
