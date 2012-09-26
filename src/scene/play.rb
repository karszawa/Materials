# -*- coding: emacs-mule -*-
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
    @level = 0

    @enemies = []
    @bullets = []

    @player = Player.new(lambda{ |blt| @bullets << blt })

    @panels = []



    # ’Àï’¾ì’¤Ë’Éü’µ¢’¤·’¤Æ’¤¤’¤ëenemies’¤Îenemy’¥ª’¥Ö’¥¸’¥§’¥¯’¥È
    def @enemies.working; select{|o| o.class != OpenStruct }; end
    # @enemies#revitalize => ’½Ð’¸½’»þ’´Ö’¤ò’²á’¤®’¤¿enemy’¤ò’½Ð’¸½’¤µ’¤»’¤ë
    def @enemies.revitalize(elap_time)
      map!{|o| (o.class == OpenStruct and o.time < elap_time) ? o.enemy : o }
    end

    # @enemies#read_db(level) => ’¥Ç’¡¼’¥¿’¥Ù’¡¼’¥¹’¤«’¤é’¥ì’¥Ù’¥ë’¤´’¤È’¤Îenemy’¤ò’ÅÐ’Ï¿’¤¹’¤ë
    def @enemies.read_db(level)
      concat(read_enemies_from_database(level))
    end
    @enemies.read_db(@level)

    # @bullets#delete_outer => ’¾ì’³°’¤Ë’½Ð’¤¿bullets’¤ò’ºï’½ü’¤¹’¤ë
    def @bullets.delete_outer
      Sprite.check($conf.divid_line, self, nil, :out)
    end
  end

  def update
    Sprite.update [@player, @enemies, @bullets, @panels]
    # Sprite.clean [@enemeis, @bullets]
    Sprite.clean @enemies
    Sprite.clean @bullets
    Sprite.clean @panels

    Sprite.check @enemies, @bullets, :hit
    Sprite.check @player, @enemies, :hit

    @bullets.delete_outer
    @enemies.revitalize(elap_time)

    if @enemies.size == 0 then
      @enemies.read_db(@level += 1)

      @next_scene =
        GameClearScene.new(player: @player, time: @time) if @enemies.size == 0

      @panels << DynamicMessagePanel.new(:levelup) unless @next_scene
    end

    @next_scene = GameOverScene.new(enemies: @enemies) if @player.vanished?
  end


  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')
  @@waku = Image.load('./img/waku.png')
  def render
    Sprite.draw [@player, @enemies, @bullets, @panels]

    Window.draw_font 10, 160, "Lv. " + @level.to_s, @@font, :z => 1000
    Window.draw_font 10, 180, "Life", @@font, :z => 1000
    Window.draw_font 50, 180, @player.life.to_s, @@font, :z => 1000

    # message_board
    Window.draw 5, 5, @@waku, 2400

    @panels.each do |panel|
      scale = [0.104 * panel.scale_x, 0.104 * panel.scale_y]
      Window.draw_ex(5,5,panel.image,scale_x: scale[0], scale_y: scale[1],
                     center_x: 0, center_y: 0, alpha: panel.alpha, z: 2500)
    end

    (@enemies.working + @bullets + [@player]).each do |obj|
      draw_point = obj.point / 10 + Point.new(5, 5)
      Window.draw_scale( *draw_point.to_a, obj.image, 0.15, 0.15, 0, 0, 2500 )
    end

    # Life gage 50,180
    Window.draw_scale( 90, 180, @@life_bar, @player.life / 300.0, 1, 0, 0, 2000)
    # Rest Enemies

    Window.draw *($conf.draw_gap.to_a), @@background_image, 0


    debug_string = "load=" + Window.get_load.round.to_s + "%"
    Window.draw_font 450, 10, debug_string, @@font, :z => 5000 if $conf.debug
  end
end


class DynamicMessagePanel < AnimeSprite
  @@images = {
    levelup: Array.new(10) do |i|
      Image.load("./img/random_stripe/random_stripe" + min(i, 9).to_s + ".png")
    end
  }

  def initialize(various)
    super 0, 0, 10

    @var = various

    add_animation :levelup, 5, (0..9).to_a + [9] * 10, :vanish

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

