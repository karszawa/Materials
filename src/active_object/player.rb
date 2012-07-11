# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Player < ActiveObject
  # 発射した弾丸をPlay#bulletsに渡すラムダを引数に持つ
  def initialize(point, blt_add)
    super point, Vector2.new(0, 0)

    @life = $conf[:player_init_life]
    @direc = Vector2.new 0, 1
    @bullet_velocity = 5

    @blt_add = blt_add
  end

  def update
    super

    $player_pnt = @point

    $conf[:draw_gap] = $conf[:show_area_center] - $player_pnt
  end

  def move
    @velocity += Input
    @velocity.size = min @velocity.size, $conf[:player_vel_limit]

    @point += @velocity
    @velocity.size *= 0.94

    @point = Point.catch $conf[:move_area_min], @point, $conf[:move_area_max]

    direc = @velocity.dup; direc.size = 1
    @direc = direc if direc.size != 0

    @sprites.each { |spr| spr.angle = Math.atan2(@direc.y, @direc.x) / Math.PI * 180}
  end

  def fire
    nomal_fire if Input.key_down? K_Z
    spiral_fire if Input.key_down? K_X
  end

  def nomal_fire
    @blt_add.call Bullet.new( @point, @direc * @bullet_velocity)
  end

  def spiral_fire
  end

  def hit(other)
    @life -= 1
  end
end


class Bullet < ActiveObject
  def initialize(point, velocity)
    super point, velocity
  end
end
