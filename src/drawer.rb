# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'
require 'pry' if $conf[:debug]

require './src/stdlib'


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


class Play < Scene
  @@font = Font.new 20
  @@completed_font = Font.new 50
  @@background_image = Image.load('./img/play_background.png')
  @@life_bar = Image.load('./img/life_bar.png')

  @@common_enemy_dead_image = Image.load_tiles('./img/common_enemy_dead.png', 4, 4)


  def draw
    Sprite.draw [@player, @enemies, @bullets, @animations].flatten

    @animations.map!{ |a| a.x += $conf[:draw_gap].x; a.y += $conf[:draw_gap].y; a}
    Sprite.draw @animations
    @animations.map!{ |a| a.x -= $conf[:draw_gap].x; a.y -= $conf[:draw_gap].y; a}

    Window.draw_font 10, 60, "Lv. " + @level.to_s, @@font, :z => 1000
    Window.draw_font 10, 80, "Life", @@font, :z => 1000
    Window.draw_font 120, 80, @player.life.to_s, @@font, :z => 1000
    Window.draw_font 10, 100,"Hiscore " + @hiscore.to_s, @@font, :z => 1000

    # enemies_mapping
    @enemies.each do |enm|
      draw_point = enm.point / 20 + Point.new(20, 0)
      Window.draw_scale( *draw_point.to_a, enm.image, 0.1, 0.1, 0, 0, 2500 )
    end

    # Life gage
    Window.draw_scale( 50, 80, @@life_bar, @player.life / 300.0, 1, 0, 0,
                       2000)
    # Rest Enemy Gage
    Window.draw_font( 130, 150, "Mission Completed!!", @@completed_font,
                      :z => 2000) if @state == :game_clear

    Window.draw *($conf[:draw_gap].to_a), @@background_image, 0
  end
end


class ActiveObject < Sprite
  def draw
    self.x += $conf[:draw_gap].x
    self.y += $conf[:draw_gap].y

    super

    self.x -= $conf[:draw_gap].x
    self.y -= $conf[:draw_gap].y
  end
end


class Player < ActiveObject
  @@image = Image.load('./img/player.png')

  def static_init
    super
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
  @@image = Image.load('./img/bullet.png')

  def static_init
    super
    self.collision = [ 11, 11, 11 ]
    self.image = @@image
  end
end


class RedEnemy < Enemy
  @@image = Image.load('./img/red_enemy.png')

  def static_init
    super
    self.collision = [22, 22, 22]
    self.image = @@image
  end
end


class BlueEnemy < Enemy
  @@image = Image.load('./img/blue_enemy.png')

  def static_init
    super
    self.collision = [14, 14, 14]
    self.image = @@image
  end
end


class YellowEnemy < Enemy
  @@image = Image.load('./img/yellow_enemy.png')

  def static_init
    super
    self.collision = [0, 0, 35, 35]
    self.image = @@image
  end
end


class GreenEnemy < Enemy
  @@image = Image.load('./img/green_enemy.png')

  def static_init
    super
    self.collision = [15, 0, 0, 32, 25, 52]
    self.image = @@image
  end
end
