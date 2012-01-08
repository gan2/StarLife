module StarLife
  class Life
    INITIAL_PD = 0.3 # 一番最初の人口密度

    attr_accessor :alive, :score
    attr_reader :x, :y, :width, :height
    
    def initialize(x, y)
      @x      = x
      @y      = y
      @width  = CELL_WIDTH
      @height = CELL_HEIGHT
      @alive  = rand(10) < INITIAL_PD * 10
      @score  = 0
    end
  end
end
