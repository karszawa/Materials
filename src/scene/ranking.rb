require './dxruby/scene'


class RankingScene < Scene::Base
  def initialize(hash = {})
    super hash
  end

  def init(hash = {})
  end

  def update
    @next_scene = SelectScene.new if Input.key_push?(K_RETURN)
  end


  @@font = Font.new 30
  def render
    Window.draw_font 120, 150, "RankingScene\nNowPrinting\nPleasePressEnter", @@font
  end
end
