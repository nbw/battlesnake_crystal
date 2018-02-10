require "./battlesnake_crystal/*"
require "kemal"

get "/" do
  "AppColony Battlesnake 2018!"
end

Kemal.run
