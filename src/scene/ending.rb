require 'dxruby'
require './dxruby/scene'


class GameClearScene < Scene::Base
  def initialize(args)
    super args
  end

  def init(args)
    @time = args[:time]
    @level = args[:level]
    @player = args[:player]
    @bullets = args[:bullets]
    @clear_time = args[:time]

    @panel = DynamicMessagePanel.new(:gameclear)
  end

  def update
    @next_scene = RankingScene.new(time: @time) if Input.key_push?(K_Z) and 3 < self.elap_time
    @next_scene = RankingScene.new(time: @time) if 10 < self.elap_time

    Sprite.update [@player, @bullets, @panel]
    @bullets.clean_outer
  end

  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')
  @@waku = Image.load('./img/waku.png')
  def render
    Sprite.draw [[@player], @bullets, [@panel]]

    Window.draw_font_ex 10, 160, "Lv. "+@level.to_s, @@font, z: 1000, shadow: true
    Window.draw_font_ex 10, 180, "Life", @@font, z: 1000, shadow: true
    Window.draw_font_ex 50, 180, @player.life.to_s, @@font, z: 1000, shadow: true

    # message_board
    Window.draw 5, 5, @@waku, 2400

    scale = [0.104 * @panel.scale_x, 0.104 * @panel.scale_y]
    Window.draw_ex(5, 5, @panel.image, scale_x: scale[0], scale_y: scale[1],
                     center_x: 0, center_y: 0, alpha: @panel.alpha, z: 2500)

    @bullets.each do |obj|
      draw_point = obj.point / 10 + Point.new(5, 5)
      Window.draw_scale( *draw_point.to_a, obj.image, 0.15, 0.15, 0, 0, 2500 )
    end

    # Rest Enemies
    Window.draw *($conf.draw_gap.to_a), @@background_image, 0

    debug_string = "load=" + Window.get_load.round.to_s + "%"
    Window.draw_font 450, 10, debug_string, @@font, :z => 5000 if $conf.debug
  end
end

class GameOverScene < Scene::Base
  def initialize(args)
    super args
  end

  def init(args)
    @enemies = args[:enemies]
    @bullets = args[:bullets]
    @level = args[:level]

    @panel = DynamicMessagePanel.new(:gameover)
  end

  def update
      @next_scene = RankingScene.new(level: @level) if Input.key_push?(K_Z) and 3 < self.elap_time
    @next_scene = RankingScene.new(level: @level) if 10 < self.elap_time

    Sprite.update [@enemies, @bullets, @panel]
    @bullets.clean_outer

    Sprite.clean @enemies; Sprite.clean @bullets;
  end


  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')
  @@waku = Image.load('./img/waku.png')
  def render
    Sprite.draw [@enemies, @bullets, [@panel]]

    Window.draw_font_ex 10, 160, "Lv. "+@level.to_s, @@font, z: 1000, shadow: true
    Window.draw_font_ex 10, 180, "Life", @@font, z: 1000, shadow: true
    Window.draw_font_ex 50, 180, "0", @@font, z: 1000, shadow: true

    # message_board
    Window.draw 5, 5, @@waku, 2400

    scale = [0.104 * @panel.scale_x, 0.104 * @panel.scale_y]
    Window.draw_ex(5, 5, @panel.image, scale_x: scale[0], scale_y: scale[1],
                     center_x: 0, center_y: 0, alpha: @panel.alpha, z: 2500)

    (@enemies.working + @bullets).each do |obj|
      draw_point = obj.point / 10 + Point.new(5, 5)
      Window.draw_scale( *draw_point.to_a, obj.image, 0.15, 0.15, 0, 0, 2500 )
    end

    # Rest Enemies
    Window.draw *($conf.draw_gap.to_a), @@background_image, 0

    debug_string = "load=" + Window.get_load.round.to_s + "%"
    Window.draw_font 450, 10, debug_string, @@font, :z => 5000 if $conf.debug
  end
end

