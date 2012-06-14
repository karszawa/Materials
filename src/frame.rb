# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'
require './active_object'
require './scenario_writer'


class Array; include ArrayExtension; end

# Frameクラス同士は出来るだけ疎結合な関係にする。
# インスタンス間に共通の情報があるのは間違っている。
class Frame
  def initialize
    @start_time = Time.now
  end

  def update
    self
  end

  def elapsed_time
    (Time.new - @start_time).to_f
  end
end


class Opening < Frame
  def initialize
    super

    @call_me_again_time = 5
  end

  def update
    return Select.new if @call_me_again_time < elapsed_time

    self
  end
end


class Select < Frame
  def initialize
    super

    @now_select = 0
    @str_list = %w[ Play Ranking ]
    @frame_class_list = [ Play, Ranking ]
  end

  def update
    @now_select = (@now_select + Input.y) % @str_list.size

    if Input.keyPush?(K_RETURN) then return @frame_class_list[@now_select].new end

    self
  end
end


# 画面に出す情報。DrawProcess側がほとんど本体
# BackGroundまで用意すると煩雑だからこちらで背景も描画しちゃう？
class HUD
  def initialize(player)
    @player = player
  end
end


class Play < Frame
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
    [@player, @enemies, @bullets].flatten.hs_each :update

    collision
    revitalize

    if @enemies.size == 0 && @enemies_bench.size == 0 then
      return self # DEBUG

      @enemies_bench = read_enemies_from_database @level += 1

      # animation

      if @enemies_bench == 0 then
        game_clear
      end
    end

    self
  end

  def revitalize
    time = Time.now - @scene_time

    0.upto @enemies_bench.size - 1 do |i|
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


class Ranking
  def initialize
    super
  end
end

