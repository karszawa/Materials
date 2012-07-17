# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

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

    @hud = HUD.new( lambda{ @level },
                    lambda{ [ @player.life, $conf[:player_init_life] ] },
                    lambda{ [ @enemies.size, @enemies_max_size ] },
                    lambda{ @enemies },
                    lambda{ @hiscore },
                    lambda{ @state } )

    @enemies_bench = read_enemies_from_database @level
    @enemies_max_size = @enemies_bench.size
  end


  def normal
    Sprite.update [@player, @enemies, @bullets].flatten

    self.collision
    self.revitalize
    self.delete_out_of_range

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

    (@enemies_bench.size - 1).downto 0 do |i|
      if @enemies_bench[i].time <= now_time then
        @enemies << @enemies_bench[i].enemy
        @enemies_bench.delete_at i
      else break end
    end
  end

  def delete_out_of_range
    @bullets.delete_if do |blt|
      blt.point_out_of_range && !Sprite.check(blt, $conf[:move_area_col])
    end
  end

  def collision
    Sprite.check @enemies, @bullets, :hit
    Sprite.clean [@enemies, @bullets].flatten

    Sprite.check @player, @enemies, :hit
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

  def draw
    Sprite.draw [@player, @enemies, @bullets, @hud].flatten
  end
end


# 画面に出す情報。DrawProcess側がほとんど本体
# BackGroundまで用意すると煩雑だからこちらで背景も描画しちゃう？
class HUD
  def initialize(level, player_life, rest_enemies, enemies, hiscore, state)
    @level = level
    @player_life = player_life
    @rest_enemies = rest_enemies # return max and now
    @enemies = enemies # point array
    @hiscore = hiscore
    @state = state
  end
end


