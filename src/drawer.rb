# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

require './src/stdlib'
require './src/hitrangeview'


def hit_range_view(collisions, point)
  return unless $conf[:debug]

  collisions.each { |obj| obj.set *(point + $conf[:draw_gap]).to_a }
  HitRange.view collisions
  collisions.each { |obj| obj.set *point.to_a }
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

class Player < ActiveObject
  @@image = Image.load('./img/player.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end


class Bullet < ActiveObject
  @@image = Image.load('./img/red_enemy.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end


class RedEnemy < Enemy
  @@image = Image.load('./img/red_enemy.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end


class BlueEnemy < Enemy
  @@image = Image.load('./img/blue_enemy.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end


class YellowEnemy < Enemy
  @@image = Image.load('./img/yellow_enemy.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end

class GreenEnemy < Enemy
  @@image = Image.load('./img/green_enemy.png')

  def draw
    Window.draw *(@point + $conf[:draw_gap]).to_a, @@image, 100

    hit_range_view @collisions, @point
  end
end
