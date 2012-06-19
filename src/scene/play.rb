# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

require './src/conf'
require './src/active_object/active_object'
require './src/scene/scene'
require './src/scenario_writer'
require './src/active_object/player.rb'


include Conf


class Array; include ArrayExtension; end


class Play < Scene
  def initialize
    super

    @level = 0
    @scene_time = Time.now

    @enemies = []
    @bullets = []
    @enemies_bench = []

    init_pnt = Point.new @@conf[:player_init_x], @@conf[:player_init_y]
    @player = Player.new init_pnt, @bullets

    @hud = HUD.new @player

    @enemies_bench = read_enemies_from_database @level
  end

  def update
    @enemies << BlueEnemy.new(Point.new( 100, 100 ), 1) if Input.keyPush?(K_RETURN)

    [@player, @enemies, @bullets].flatten.hs_each :update

    collision
    revitalize

    if @enemies.size == 0 && @enemies_bench.size == 0 then
      return self # DEBUG

      @enemies_bench = read_enemies_from_database @level += 1
      @scene_time = Time.now

      # animation

      if @enemies_bench == 0 then
        game_clear
      end
    end

    self
  end

  def revitalize
    time = Time.now - @scene_time

    (@enemies_bench.size - 1).downto 0 do |i|
      if @enemies_bench[i].time <= time then
        @enemies << @enemies_bench[i].enemy
        @enemies_bench.delete_at i
      else break end
    end
  end

  def collision
    @enemies.size.downto 1 do |enm|
      @bullets.size.downto 1 do |blt|
        bc = @bullets[blt - 1].collisions; ec = @enemies[enm - 1].collisions

        if Collision.check bc, ec then
          @bullets.delete_at(blt - 1)
          @enemies.delete_at(enm - 1) if @enemies[enm - 1].life <= 0
          break
        end
      end
    end

    @enemies.size.downto 1 do |enm|
      pc = @player.collisions; ec = @enemies[enm - 1].collisions

      if Collision.check pc, ec then
        @enemies.delete_at(enm - 1) if @enemies[enm - 1].life <= 0

        game_over if @player.life <= 0
      end
    end
  end

  def game_over
    # animation
  end

  def game_clear
    # animetion
  end

  def draw
    [@player, @enemies, @bullets, @hud].flatten.hs_each :draw
  end
end


# 画面に出す情報。DrawProcess側がほとんど本体
# BackGroundまで用意すると煩雑だからこちらで背景も描画しちゃう？
class HUD
  def initialize(player)
    @player = player
  end
end


