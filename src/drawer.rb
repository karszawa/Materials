# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'
require 'pry'

require './src/stdlib'
require './src/hitrangeview'


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
    Window.draw_font 10, 60, "Lv. " + @level.call.to_s, @@font, :z => 1000
    Window.draw_font 10, 80, "Life", @@font, :z => 1000
    Window.draw_font 100, 80, @player_life.call[0].to_s, @@font, :z => 1000
    Window.draw_font 10, 100,"Hiscore " + @hiscore.call.to_s, @@font, :z => 1000

    # enemies_mapping
    # Life Gage
    # Rest Enemy Gage

    Window.draw *($conf[:draw_gap].to_a), @@image, 0
  end
end


class ActiveObject < Sprite
  def draw
    self.x += $conf[:draw_gap].x; self.y += $conf[:draw_gap].y

    super

    self.x -= $conf[:draw_gap].x; self.y -= $conf[:draw_gap].y
  end
end


class Player < ActiveObject
  @@image = Image.load('./img/player.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 500

    # 衝突範囲が複数あるから、それらに共通する回転の中心を与えなければいけない。
    self.center_x = @@image.width / 2
    self.center_y = @@image.height / 2

    self.collision = [
                      [ 22, 22, 22 ],
                      [ 17, 0, 0, 28, 35, 28 ],
                      [ 11, 30, 24, 47 ],
                      [ 18, 56, 11, 30, 24, 47 ]
                     ]

    self.image = @@image
  end
end


class Bullet < ActiveObject
  @@image = Image.load('./img/red_enemy.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100

    self.collision = [ 22, 22, 22 ]

    self.image = @@image
  end
end


class RedEnemy < Enemy
  @@image = Image.load('./img/red_enemy.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100

    self.image = @@image

    self.collision = [22, 22, 22]
  end
end


class BlueEnemy < Enemy
  @@image = Image.load('./img/blue_enemy.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100

    self.collision = [14, 14, 14]

    self.image = @@image
  end
end


class YellowEnemy < Enemy
  @@image = Image.load('./img/yellow_enemy.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100

    self.collision = [0, 0, 35, 35]

    self.image = @@image
  end
end


class GreenEnemy < Enemy
  @@image = Image.load('./img/green_enemy.png')

  def static_init
    self.x = @point.x
    self.y = @point.y
    self.z = 100

    self.collision = [15, 0, 0, 32, 25, 52]

    self.image = @@image
  end
end
