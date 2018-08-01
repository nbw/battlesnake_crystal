require "kemal"
require "json"
require "colorize"
require "../manifest"

Kemal.config.port = 3001

get "/" do
  "Crystal Battlesnake 2018!"
end

post "/start" do |env|
	{
    color: ENV.fetch("COLOR","#00C5E9"),
    secondary_color: ENV.fetch("SECONDARY_COLOR","#123456"),
    head_url: ENV.fetch("AVATAR", "https://im-01.gifer.com/6ka.gif"),
		name: "AppColony",
    taunt: ENV.fetch("TAUNT", "AppColony "),
		head_type: "pixel",
		tail_type: "pixel"
  }.to_json
end

post "/move" do |env|
  # retrieve json body
  json =  env.request.body.not_nil!.gets_to_end

  # generate world
  world = World.new(json)
  
  # calculate resulting move
  move = world.calculate

	{
  	move: move,
    taunt: Taunts.next(json)
  }.to_json
end

Kemal.run
