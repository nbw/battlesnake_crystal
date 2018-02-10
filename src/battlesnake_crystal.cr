require "./battlesnake_crystal/*"
require "kemal"

get "/" do
  "Hello World!"
end

Kemal.run
