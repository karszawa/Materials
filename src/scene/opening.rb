require './dxruby/scene'


class OpeningScene < Scene::Base
  def init
    @trans_time = 5.0
  end

  def update
    @next_scene = SelectScene.new if @trans_time < elap_time
  end

  @@font = Font.new(30)
  def render
    rest_time = @trans_time - elap_time

    Window.draw_font(0, 0, "Now Opening... #{rest_time.ceil}", @@font)
  end
end
