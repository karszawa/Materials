# -*- coding: utf-8 -*-
require 'dxruby'
require './active_object'


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
    @str_list = %w[ Play, Ranking ]
    @frame_class_list = [ Play, Ranking ]
  end

  def update
    @now_select = (@now_select + Input.y) % @value_list.size

    if Input.keyPush?(K_RETURN) then return @frame_class_list[@now_select].new end

    self
  end
end


# 画面に出す情報。DrawProcess側がほとんど本体
class HUD
  def initialize(player)
    @player = player
  end
end


class Play < Frame
  def initialize
    super

    @enemies = []
    @bullets = []

    init_pnt = Point.new @@conf[:player_init_x], @@conf[:player_init_y]
    @player = Player.new init_pnt, @bullets

    @hud = HUD.new @player
  end

  def update
    [@player, @enemies, @bullets].flatten.hs_each :update

    collison
  end

  def collision
    enemies.size.downto 0 do |enm|

      bullets.size.downto 0 do |blt|
        bc = bullets[blt - 1].collisions; ec = enemies[enm - 1].collisions

        if Collision.check bc, ec then
          bullets.delete_at(blt - 1)
          enemies.delete_at(enm - 1) if enemies[enm - 1].life <= 0
          break
        end
      end
    end

    enemies.size.downto 0 do |enm|
      if Collision.check @player.collisions, enemies[enm - 1] then
        enemies.delete_at(enm - 1) if enemies[enm - 1].life <= 0

        game_over if @player.life <= 0
      end
    end
  end

  def game_over
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

