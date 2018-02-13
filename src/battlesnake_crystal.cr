require "kemal"
require "json"
require "./*"

get "/" do
  "AppColony Battlesnake 2018!"
end

post "/start" do |env|
	{
		color: "#123456",
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
  
  # generate world
  world = World.new(json)
  
  # calculate resulting move
  move = world.calculate

	{
  	move: move,
  	taunt: ""
	}.to_json
end

Kemal.run
