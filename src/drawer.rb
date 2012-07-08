# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

require './src/stdlib'
require './src/hitrangeview'


# Spriteにすると怪しい…
def hit_range_view(sprites, point)
  return unless $conf[:debug]

  collisions = sprites.map{ |spr| spr.collision }

  collisions.each { |obj| obj.collision.set *(point + $conf[:draw_gap]).to_a }
  HitRange.view collisions
  collisions.each { |obj| obj.sollision.set *point.to_a }
end


class Opening < Scene
  @@font = Font.new 30

  def draw
    wait_time = @call_me_again_time - elapsed_time.floor

    Window.draw_font 0, 0, "Now Opening... #{wait_time}", @@font
  end
end


class Select < Scene
  @@font = Font.new 20

  def draw
    base_x = 150; base_y = 100

    @str_list.each_with_index do |name, idx|
      dx = (@now_select == idx ? -50 : 0)
      Window.draw_font base_x + dx, base_y += 50, name, @@font
    end
  end
end


class HUD
  @@font = Font.new 20
  @@image = Image.load('./img/play_background.png')

  def draw
    # player life
    # rest enemies
    # hiscore

    Window.draw *($conf[:draw_gap].to_a), @@image, 0

    Window.draw_font 0, 0, @scene.size.to_s, @@font
  end
end


class ActiveObject
  def draw
    @sprites.each{ |spr| spr.x += $conf[:draw_gap].x; spr.y += $conf[:draw_gap].y }

    Sprite.draw @sprites

    @sprites.each{ |spr| spr.x -= $conf[:draw_gap].x; spr.y -= $conf[:draw_gap].y }
  end
end


class Player < ActiveObject
  @@image = Image.load('./img/player.png')

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [ 22, 22, 22 ]
    tmp.z = 100
    @sprites << tmp
  end
end


class Bullet < ActiveObject
  @@image = Image.load('./img/red_enemy.png')

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [ 22, 22, 22 ]
    tmp.z = 100
    @sprites << tmp
  end
end


class RedEnemy < Enemy
  @@image = Image.load('./img/red_enemy.png')

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [22, 22, 22]
    tmp.z = 10
    @sprites << tmp
  end
end


class BlueEnemy < Enemy
  @@image = Image.load('./img/blue_enemy.png')

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [14, 14, 14]
    tmp.z = 10
    @sprites << tmp
  end
end


class YellowEnemy < Enemy
  @@image = Image.load('./img/yellow_enemy.png')

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [0, 0, 35, 35]
    tmp.z = 100
    @sprites << tmp
  end
end


class GreenEnemy < Enemy
  @@image = Image.load('./img/green_enemy.png')
  @@img_size = Vector2.new @@image.width, @@image.height

  def sprite_init
    tmp = Sprite.new(*@point.to_a, @@image)
    tmp.collision = [15, 0, 0, 32, 25, 52]
    tmp.z = 100
    @sprites << tmp
  end
end
