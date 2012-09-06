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



    # ’½Ð’¸½’¤·’¤¿’Å¨’¤È’ÂÔ’µ¡’Ãæ’¤Î’Å¨’¤Î’¶­’³¦’Àþ
    def @enemies.divid_line; @divid_line ||= 0; end
    def @enemies.divid_line=(val); @divid_line = val; end
    # @enemies#revitalize => ’½Ð’¸½’»þ’´Ö’¤ò’²á’¤®’¤¿enemy’¤ò’½Ð’¸½’¤µ’¤»’¤ë
    def @enemies.revitalize(elap_time)
      while self[divid_line] and elap_time < self[divid_line].time
        self[divid_line] = self[divid_line].enemy
        divid_line += 1
      end
    end

    # @enemies#read_db(level) => ’¥Ç’¡¼’¥¿’¥Ù’¡¼’¥¹’¤«’¤é’¥ì’¥Ù’¥ë’¤´’¤È’¤Îenemy’¤ò’ÅÐ’Ï¿’¤¹’¤ë
    def @enemies.read_db(level)
      self.concat(read_enemies_from_database(level))
    end
    @enemeis.read_db(@level)

    # @bullets#delete_outer => ’¾ì’³°’¤Ë’½Ð’¤¿bullets’¤ò’ºï’½ü’¤¹’¤ë
    def @bullets.delete_outer
      Sprite.check($conf.move_area_col, range, self, nil, out)
    end
  end

  def update
    Sprite.update [@player, @enemies, @bullets].flatten
    Sprite.clean [@enemeis, @bullets].flatten

    self.collision
    @bullets.delete_outer
    @enemies.revitalize(elap_time)

    if @enemies.size == 0 then
      @enemies.read_db(@level += 1)

      @next_scene =
        GameClearScene.new(player: @player, time: @time) if @enemies.size == 0
    end

    @next_scene = GameOverScene.new(enemies: @enemies) if @player.vanished?
  end

  def collision
    Sprite.check @enemies, @bullets, :hit
    Sprite.check @player, @enemies, :hit
  end


  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')

  def render
    Sprite.draw [@player, @enemies, @bullets].flatten


    Window.draw_font 10, 60, "Lv. " + @level.to_s, @@font, :z => 1000
    Window.draw_font 10, 80, "Life", @@font, :z => 1000
    Window.draw_font 120, 80, @player.life.to_s, @@font, :z => 1000

    # enemies_mapping
    @enemies.each do |enm|
      draw_point = enm.point / 20 + Point.new(20, 0)
      Window.draw_scale( *draw_point.to_a, enm.image, 0.1, 0.1, 0, 0, 2500 )
    end

    # Life gage
    Window.draw_scale( 50, 80, @@life_bar, @player.life / 300.0, 1, 0, 0, 2000)
    # Rest Enemies

    Window.draw *($conf.draw_gap.to_a), @@background_image, 0
  end
end
