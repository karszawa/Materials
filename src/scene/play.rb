# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'
require './dxruby/scene'
require './dxruby/anime_sprite'

require './src/conf'
require './src/scenario_writer'
require './src/active_object/active_object'
require './src/active_object/player.rb'
require './src/scene/ending.rb'

class Array; include ArrayExtension; end


class PlayScene < Scene::Base
  def init
    @player = Player.new(lambda{ |blt| @bullets << blt })

    @level = 0

    @enemies = []
    @bullets = []

    @panels = []

    @scenario_begin_time = 0

    def @enemies.working; select{|o| o.class != OpenStruct }; end

    def @enemies.revitalize(elap_time)
      map!{|o| (o.class == OpenStruct and o.time < elap_time) ? o.enemy : o }
    end

    def @enemies.read_db(level)
      concat(read_enemies_from_database(level))
    end

    def @bullets.clean_outer
      Sprite.check($conf.divid_line, self, nil, :out)
    end

    def @enemies.scenario_clear?
      self.count{ |x| x.silver } == self.size
    end

    @enemies.read_db(@level)
    @panels << DynamicMessagePanel.new(:howto)


    @@bgm.play
  end

  def quit
    @@bgm.stop
  end

  def update
    Sprite.update [@player, @enemies, @bullets, @panels]
    Sprite.clean @enemies; Sprite.clean @bullets; Sprite.clean @panels

    Sprite.check @enemies, @bullets, :hit
    Sprite.check @player, @enemies, :hit

    @bullets.clean_outer
    @enemies.revitalize(elap_time - @scenario_begin_time)

    if @enemies.scenario_clear?
      @enemies.clear
      @enemies.read_db(@level += 1)

      @next_scene = GameClearScene.new(player: @player, bullets: @bullets,
                                       level: @level) if @enemies.size == 0

      @panels << DynamicMessagePanel.new(:levelup) unless @next_scene

      @scenario_begin_time = elap_time
      @@levelup_se.play
    end

    if @player.vanished?
      args = {enemies: @enemies, bullets: @bullets, level: @level}
      @next_scene = GameOverScene.new(args)
    end
  end


  @@bgm = Sound.new('./snd/play.wav'); @@bgm.loop_count = -1
  @@levelup_se = Sound.new('./snd/levelup.wav')
  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')
  @@waku = Image.load('./img/waku.png')
  def render
    Sprite.draw [@player, @enemies, @bullets, @panels]

    Window.draw_font_ex 220, 40, "Lv. "+(@level+1).to_s, @@font, z: 1000, shadow: true,edge: true, edge_width: 1, edge_color: [102, 255, 0], edge_level: 2
    Window.draw_font_ex 220, 10, "Life "+@player.life.to_s, @@font, z: 1000, shadow: true, edge: true, edge_width: 1, edge_color: [255, 102, 102], edge_level: 2

    # message_board
    Window.draw 10, 10, @@waku, 2400

    @panels.each do |panel|
      scale = [0.104 * panel.scale_x, 0.104 * panel.scale_y]
      Window.draw_ex(5,5,panel.image,scale_x: scale[0], scale_y: scale[1],
                     center_x: 0, center_y: 0, alpha: panel.alpha, z: 2500)
    end

    (@enemies.working + @bullets + [@player]).each do |obj|
      ratio = 0.1
      draw_point = obj.point * ratio + Point.new(10, 10)
      draw_point.x -= obj.image.width * ratio
      draw_point.y -= obj.image.height * ratio
      Window.draw_scale( *draw_point.to_a, obj.image, 0.15, 0.15, 0, 0, 2500 )
    end

    # Life gage 50,180
    bar_len = 1.0*@player.life/$conf.player_max_hp*15
    Window.draw_scale(310, 10, @@life_bar, bar_len, 1, 0, 0, 2000)

    # Rest Enemies
    Window.draw *($conf.draw_gap.to_a), @@background_image, 0


    debug_string = "load=" + Window.get_avg_load.round.to_s + "%" if $conf.debug
    Window.draw_font 450, 500, debug_string, @@font, :z => 5000 if $conf.debug
  end
end


class DynamicMessagePanel < AnimeSprite
  @@images = {
    levelup: Array.new(10) do |i|
      Image.load("./img/levelup/random_stripe" + min(i, 9).to_s + ".png")
    end,
    howto: Array.new(10) do |i|
      Image.load("./img/howto/random_stripe" + i.to_s + ".png")
    end,
    gameover: Array.new(10) do |i|
      Image.load("./img/gameover/random_stripe" + i.to_s + ".png")
    end,
    gameclear: Array.new(10) do |i|
      Image.load("./img/gameclear/random_stripe" + i.to_s + ".png")
    end,
  }

  def initialize(various)
    super 0, 0, 10

    @var = various

    add_animation :howto, 5, (0..9).to_a + [9] * 100, :vanish
    add_animation :levelup, 5, (0..9).to_a + [9] * 10, :vanish
    add_animation :gameover, 5, (0..9).to_a + [9] * 1000, :vanish
    add_animation :gameclear, 5, (0..9).to_a + [9] * 1000, :vanish

    self.animation_image = @@images[@var]
    self.center_x = 0
    self.center_y = 0
    self.scale_x = 1920.0 / @@images[@var][0].width
    self.scale_y = 1440.0 / @@images[@var][0].height

    start_animation(@var)
  end

  def draw
    self.x = $conf.draw_gap.x
    self.y = $conf.draw_gap.y

    p = 1.0*(progress[0]-@@images[@var].size-1)/(progress[1]-@@images[@var].size)
    self.alpha = 255.0 * (1 - p) if 0 <= p
    super
  end
end

