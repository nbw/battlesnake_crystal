module API
  class Parser

    def initialize(body : JSON::Any)
      @body = body 
    end

    def width
      @body["width"]
    end

    def height
      @body["height"]
    end

    def turn
      @body["turn"]
    end

    def snakes
      @body["snakes"]["data"]
    end

    def food
      @body["food"]["data"]
    end

    def me
      me = @body["you"]
    end
  end
end
