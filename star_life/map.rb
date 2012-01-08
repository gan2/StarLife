require 'star_life/config'
require 'star_life/life'

module StarLife
  class Map
    attr_reader :width, :height
    
    def initialize
      @width  = MAP_WIDTH
      @height = MAP_HEIGHT
      @map    = MapArray.new(@height) { MapArray.new(@width) }
      @height.times do |y|
        @width.times do |x|
          @map[y][x] = Life.new(x, y)
        end
      end
    end

    def [](idx)
      @map[idx]
    end

    def []=(idx, val)
      @map[idx] = val
    end

    def in?(x, y)
      (MAP_WINDOW_X <= x and x <= MAP_WINDOW_X + MAP_WINDOW_WIDTH ) and
        (MAP_WINDOW_Y <= y and y <= MAP_WINDOW_Y + MAP_WINDOW_HEIGHT)
    end
  end

  class MapArray < Array
    alias_method(:org_get, :[])
    alias_method(:org_set, :[]=)
    
    def [](idx)
      org_get(idx % self.size)
    end
    
    def []=(idx, val)
      org_set(idx % self.size, val)
    end
  end
end
