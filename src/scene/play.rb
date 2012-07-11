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

    @enemies = []
    @bullets = []
    @enemies_bench = []

    @player = Player.new lambda{ |blt| @bullets << blt }

    @hud = HUD.new( lambda{ @level },
                    lambda{ [ @player.life, $conf[:player_init_life] ] },
                    lambda{ [ @enemies.size, @enemies_max_size ] },
                    lambda{ @enemies.map{ |enm| enm.point } },
                    lambda{ @hiscore } )

    @enemies_bench = read_enemies_from_database @level
    @enemies_max_size = @enemies_bench.size
  end

  def update
    Sprite.update [@player, @enemies, @bullets].flatten

    self.collision
    self.revitalize
    self.delete_out_of_range

    if @enemies.size == 0 && @enemies_bench.size == 0 then
      return self # DEBUG

      @enemies_bench = read_enemies_from_database @level += 1
      @enemies_max_size = @enemies_bench.size
      @scene_time = Time.now

      # animation

      if @enemies_bench == 0 then
        self.game_clear
      end
    end

    self
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

    self.game_over if @player.vanished?
  end

  def game_over
    # animation
  end

  def game_clear
    # animetion
  end

  def draw
    Sprite.draw [@player, @enemies, @bullets, @hud].flatten
  end
end


# 画面に出す情報。DrawProcess側がほとんど本体
# BackGroundまで用意すると煩雑だからこちらで背景も描画しちゃう？
class HUD
  def initialize(level, player_life, rest_enemies, enemies_position, hiscore)
    @level = level
    @player_life = player_life
    @rest_enemies = rest_enemies # return max and now
    @enemies_position = enemies_position # point array
    @hiscore = hiscore
  end
end


