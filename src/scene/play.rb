# -*- coding: emacs-mule -*-
require 'dxruby'
require 'dxrubyex'
require './dxruby/anime_sprite'

require './src/conf'
require './src/active_object/active_object'
require './src/scene/scene'
require './src/scenario_writer'
require './src/active_object/player.rb'

class Array; include ArrayExtension; end


class Play < Scene
  def initialize
    super

    @level = 0
    @hiscore = 0
    @state = :normal

    @enemies = []
    @bullets = []
    @enemies_bench = []

    @player = Player.new lambda{ |blt| @bullets << blt }

    @enemies_bench = read_enemies_from_database @level
    @enemies_max_size = @enemies_bench.size

    @animations = []
    # ’Å¨’¤¬’»à’¤ó’¤À’»þ’»à’Ë´’¥¢’¥Ë’¥á’¡¼’¥·’¥ç’¥ó’¤ò’³«’»Ï’¤¹’¤ë
    # += ’¤Ç’·ë’¹ç’¤¹’¤ë’¤È’¤³’¤Î’¥á’¥½’¥Ã’¥É’¤¬’¾Ã’ÌÇ’¤·’¤Æ’¤·’¤Þ’¤¦
    def @enemies.dead_animations
      select(&:vanished?).map do |enm|
        tmp = AnimeSprite.new
        tmp.x = enm.x + $conf[:draw_gap].x
        tmp.y = enm.y + $conf[:draw_gap].y
        tmp.z = 120
        tmp.animation_image = @@common_enemy_dead_image
        tmp.start_animation(5, (0..15).to_a, :vanish)
      end
    end
  end

  def normal
    Sprite.update [@player, @enemies, @bullets, @animations].flatten
    Sprite.clean @animations

    self.collision
    self.revitalize
    self.delete_out_of_area

    self.read_enemies
  end

  def read_enemies
    if @enemies.size + @enemies_bench.size == 0 then

      @enemies_bench = read_enemies_from_database @level += 1
      @enemies_max_size = @enemies_bench.size

      # animation

      return :game_clear if @enemies_max_size == 0
    end

    return :game_over if @player.vanished?

    :normal
  end

  def revitalize
    now_time = Time.now - @start_time

    # += ’¤Ç’·ë’¹ç’¤¹’¤ë’¤È’ÆÃ’°Û’¥á’¥½’¥Ã’¥É’¤¬’¾Ã’ÌÇ’¤·’¤Æ’¤·’¤Þ’¤¦
    @enemies.concat @enemies_bench.delete_heads!{|o| o.time<=now_time}.map(&:enemy)
  end

  def delete_out_of_area
    range = $conf[:move_area_col]

    @bullets.select{ |o| o.out_of_area && !Sprite.check(o, range) }.each(&:out)

    Sprite.clean @bullets
  end

  def collision
    Sprite.check @enemies, @bullets, :hit
    @animations += @enemies.dead_animations
    Sprite.clean [@enemies, @bullets].flatten

    Sprite.check @player, @enemies, :hit
    @animations += @enemies.dead_animations
    Sprite.clean @enemies
  end

  def game_over
    # animation
    Select.new
  end

  def game_clear_init
    @game_clear_time = Time.now
    @wait = 5
  end

  def game_clear
    return Select.new if @game_clear_time + @wait < Time.now

    Sprite.update [@player, @bullets].flatten

    :game_clear
  end
end
