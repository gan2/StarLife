include StarRuby
require 'star_life/config'

module StarLife
  class View
    private
    def render_text(screen, text, x, y, in_window = false)
      fore_color = in_window ? Color.new(255, 255, 255) : Color.new(51, 51, 153)
      screen.render_text(text, x + 1, y + 1, @font, Color.new(0, 0, 0, 64))
      screen.render_text(text, x, y, @font, fore_color)
      # screen.render_text(text, x + 1, y + FONT_SIZE + 1, @font, Color.new(0, 0, 0, 64))
      # screen.render_text(text, x, y + FONT_SIZE, @font, fore_color)
    end
    
    def initialize
      @textures = {
        :none          => Texture.load('img/none.png'),
        :life          => Texture.load('img/life.png'),
        :cursor        => Texture.load('img/cursor.png'),
        :map_window    => Texture.new(MAP_WINDOW_WIDTH, MAP_WINDOW_HEIGHT),
        :status_window => Texture.new(STATUS_WINDOW_WIDTH, STATUS_WINDOW_HEIGHT),
        :start_info    => Texture.new(SCREEN_WIDTH, SCREEN_HEIGHT),
        :pause_info    => Texture.new(SCREEN_WIDTH, SCREEN_HEIGHT),
      }
      @font = Font.new('fonts/ORANGEKI', FONT_SIZE)

      texture = @textures[:start_info]
      texture.fill(Color.new(0, 0, 0, 128))
      str = "PRESS ANY KEY TO PLAY"
      width, height = @font.get_size(str)
      render_text(texture, str,
        (texture.width - width) / 2, (texture.height - height) / 2, true)

      texture = @textures[:pause_info]
      texture.fill(Color.new(0, 0, 0, 128))
      str = "PRESS ANY KEY TO PLAY"
      width, height = @font.get_size(str)
      render_text(texture, str,
        (texture.width - width) / 2, (texture.height - height) / 2, true)
    end

    public
    def update(model, screen)
      # clear windows
      @textures.keys.select{|k| k.to_s =~ /window$/}.each do |key|
        @textures[key].fill(Color.new(0, 0, 0, 192))
      end

      if [:playing].include?(model.state)
        # マップウィンドウの描画
        window = @textures[:map_window]
        map    = model.map
        map.height.times do |y|
          map.width.times do |x|
            texture = map[y][x].alive ? @textures[:life] : @textures[:none]
            window.render_texture(texture, x * CELL_WIDTH, y * CELL_HEIGHT)
          end
        end
        # デバッグモードのときはスコアも描画
        if model.debug_mode
          map.height.times do |y|
            map.width.times do |x|
              render_text(window, "%2d" % map[y][x].score, x * CELL_WIDTH, y * CELL_HEIGHT, true)
            end
          end
        end

        # カーソルの描画
        x, y = Input.mouse_location
        if map.in?(x, y)
          x = x / CELL_WIDTH * CELL_WIDTH - CELL_WIDTH
          y = y / CELL_HEIGHT * CELL_HEIGHT - CELL_HEIGHT
          window.render_texture(@textures[:cursor], x, y)
        end

        # ステータスウィンドウの描画
        window = @textures[:status_window]
        render_text(window, "Generation : #{model.generation}", 0, 0, true)
        render_text(window, "Interval : #{model.interval}", 0, CELL_HEIGHT, true)
        render_text(window, "Debug Mode : #{model.debug_mode}", 0, CELL_HEIGHT * 2, true)
      end

      screen.clear
      screen.render_texture(@textures[:map_window], MAP_WINDOW_X, MAP_WINDOW_Y)
      screen.render_texture(@textures[:status_window], STATUS_WINDOW_X, STATUS_WINDOW_Y)

      case model.state
      when :start
        screen.render_texture(@textures[:start_info], 0, 0)
      when :pause
        screen.render_texture(@textures[:pause_info], 0, 0)
      when :gameover
        # screen.render_texture(@textures[:gameover_info], 0, 0)
      end
    end

  end
end
