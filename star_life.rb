qrequire 'starruby'
require 'star_life/config'
require 'star_life/model'
require 'star_life/controller'
require 'star_life/view'
include StarLife

def main
  model      = StarLife::Model.new
  controller = StarLife::Controller.new
  view       = StarLife::View.new
  StarRuby::Game.title = GAME_TITLE
  
  StarRuby::Game.run(SCREEN_WIDTH, SCREEN_HEIGHT, :window_scale => WINDOW_SCALE) do
    Game.terminate if (Input.keys(:keyboard) & [:escape, :q]).size > 0
    controller.update(model)
    view.update(model, StarRuby::Game.screen)
    GC.start
  end
end

main
