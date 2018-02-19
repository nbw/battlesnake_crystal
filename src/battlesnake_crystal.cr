require "kemal"
require "json"
require "colorize"
require "../battlesnake_crystal/world"
require "../battlesnake_crystal/grid"
require "../battlesnake_crystal/voronoi"
require "../battlesnake_crystal/survival_snake"
require "../battlesnake_crystal/battlesnake_api"
require "../battlesnake_crystal/connected_components"

Kemal.config.port = 3001

get "/" do
  "AppColony Battlesnake 2018!"
end

post "/start" do |env|
	{
		color: "#123456",
		secondary_color: "#123456",
    head_url: "https://im-01.gifer.com/6ka.gif",
		name: "AppColony",
		taunt: "",
		head_type: "pixel",
		tail_type: "pixel"
  }.to_json
end

post "/move" do |env|
  # retrieve json body
  json =  env.request.body.not_nil!.gets_to_end

  # gGridPointenerate world
  world = World.new(json)
  
  # calculate resulting move
  move = world.calculate

	{
  	move: move,
  	taunt: ""
	}.to_json
end

Kemal.run
