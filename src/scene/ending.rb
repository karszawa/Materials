require 'dxruby'
require './dxruby/scene'


class GameClearScene < Scene::Base
  def initialize(hash)
    super hash
  end

  def init(hash)
    @player = hash[:player]
    @clear_time = hash[:time]
  end

  def update
    @next_scene = RankingScene.new if Input.key_push?(K_RETURN)
  end


  @@font = Font.new(50)
  def render
    Window.draw_font 120, 150, "GameClearScene\nNowPrinting\nPleasePressEnter", @@font
  end
end

class GameOverScene < Scene::Base
  def initialize(hash)
    super hash
  end

  def init(hash)
    @enemies = hash[:enemies]
  end

  def update
    @next_scene = RankingScene.new if Input.key_push?(K_RETURN)
  end


  @@font = Font.new(50)
  def render
    Window.draw_font 120, 150, "GameOverScene\nNowPrinting\nPleasePressEnter", @@font
  end
end

