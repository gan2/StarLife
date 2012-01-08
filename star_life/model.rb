require 'star_life/map'
require 'star_life/life'

module StarLife
  class Model
    D_INTERVAL = 0.01
    
    attr_reader :state, :map, :generation, :interval, :debug_mode
    
    def initialize
      start
    end

    def start
      @state      = :start
      @interval   = 0.15
      init
    end
    
    def init
      @score      = 0
      @map        = Map.new
      @generation = 0
      @time       = Time.new
      @debug_mode = false
    end

    def start_playing
      @state = :playing
    end

    def pause
      @state = :pause if @state == :playing
    end

    def resume
      @state = :playing if @state == :pause
    end

    def extend_interval
      @interval += D_INTERVAL
    end

    def shorten_interval
      @interval -= D_INTERVAL
      @interval = 0 if @interval < 0
    end
    
    def toggle_debug_mode
      @debug_mode = (not @debug_mode)
    end

    def click
      x, y = Input.mouse_location
      if @map.in?(x, y)
        x = x / CELL_WIDTH - 1
        y = y / CELL_WIDTH - 1
        @map[y][x].alive = true
      end
    end

    def go_next_generation
      return unless Time.new - @time > @interval
      @time = Time.new

      # スコアの計算
      # スコアは一旦 score_map に保存してから Life.score にコピーしている
      # 直接 Life.score に保存するとうまくいかない。原因不明
      score_map = MapArray.new(@map.height) { MapArray.new(@map.width) { 0 } }
      @map.height.times do |cell_y|
        @map.width.times do |cell_x|
          next unless @map[cell_y][cell_x].alive
          (-1..1).each do |x|
            (-1..1).each do |y|
              score = (x == 0 && y  == 0 ? 10 : 1)
              score_map[cell_y + y][cell_x + x] += score
            end
          end
        end
      end
      @map.height.times do |cell_y|
        @map.width.times do |cell_x|
          @map[cell_y][cell_x].alive = [3, 12, 13].include?(score_map[cell_y][cell_x])
          @map[cell_y][cell_x].score = score_map[cell_y][cell_x]
        end
      end
      @generation += 1
    end
  end
end
