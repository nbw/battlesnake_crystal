require "kemal"

# Matches GET "http://host:port/"
get "/" do
  "Hello World!"
end

Kemal.run
