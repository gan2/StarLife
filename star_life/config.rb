require 'pp'

module StarLife
  FONT_SIZE            = 16
  CELL_WIDTH           = 16
  CELL_HEIGHT          = 16
  
  MAP_WIDTH            = 20
  MAP_HEIGHT           = 20
  MAP_WINDOW_X         = CELL_WIDTH
  MAP_WINDOW_Y         = CELL_HEIGHT
  MAP_WINDOW_WIDTH     = CELL_WIDTH * MAP_WIDTH
  MAP_WINDOW_HEIGHT    = CELL_HEIGHT * MAP_HEIGHT
  
  STATUS_WINDOW_X      = MAP_WINDOW_WIDTH + CELL_WIDTH * 2
  STATUS_WINDOW_Y      = CELL_HEIGHT
  STATUS_WINDOW_WIDTH  = 128
  STATUS_WINDOW_HEIGHT = 128
  
  GAME_TITLE           = 'Star Life'
  SCREEN_WIDTH         = STATUS_WINDOW_WIDTH + MAP_WINDOW_WIDTH + CELL_WIDTH * 3
  SCREEN_HEIGHT        = MAP_WINDOW_HEIGHT + CELL_HEIGHT * 2
  WINDOW_SCALE         = 1
end

class Fixnum
  include StarLife
  
  def convert2mapx
    self / CELL_WIDTH
  end

  def convert2mapy
    self / CELL_HEIGHT
  end
end
