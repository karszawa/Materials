# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Player < ActiveObject
  # 発射した弾丸をPlay#bulletsに渡すラムダを引数に持つ
  def initialize(blt_add)
    super $conf.player_init_point, Vector2.new

    @life = $conf.player_init_life
    @direc = Vector2.new(0, 1)
    @bullet_velocity = 10

    @blt_add = blt_add

    $conf.draw_gap = $conf.show_area_center - @point

    add_animation :fight, 1, [0], :fight
    start_animation :fight
  end

  def update
    super

    $player_pnt = @point

    $conf.draw_gap = $conf.show_area_center - $player_pnt
  end

  def move
    @velocity += Input
    @velocity.size = min(@velocity.size, $conf.player_vel_limit)

    @point += @velocity
    @velocity.size *= 0.94

    direc = @velocity.dup; direc.size = 1
    @direc = direc if direc.size != 0

    self.angle = Math.atan2(@direc.y, @direc.x) / Math.PI * 180 + 90

    @point = Point.catch($conf.move_area_min, @point, $conf.move_area_max)
  end

  def fire
    self.nomal_fire if Input.key_down? K_Z
    self.spiral_fire if Input.key_down? K_X
  end

  def nomal_fire
    position = @point + @direc * 50
    position.x += @@image.width / 2
    position.y += @@image.height / 2

    @blt_add.call Bullet.new(position, @direc * @bullet_velocity)
  end

  def spiral_fire
    num = 20

    position = @point + Point.new(@@image.width / 2, @@image.height / 2)

    num.times do |i|
      direc = Vector2.polar(i * 2.0 * Math.PI / num, 1.0)
      @blt_add.call Bullet.new( position + direc * 50, direc * @bullet_velocity )
    end

    @life -= 20

    self.vanish if @life <= 0
  end

  def hit(other)
    @life -= 1

    self.vanish if @life <= 0
  end


  @@image = Image.load('./img/player.png')
  def init
    self.collision = [[ 0, -29, -18, 1, 18, 1 ], [ 0, 29, -10, 1, 10, 1 ]]
    self.animation_image = [@@image]
  end
end


class Bullet < ActiveObject
  def initialize(point, velocity)
    super point, velocity

    add_animation :exit, 1, (0..7).to_a, :vanish
    add_animation :fight, 1, [0], :fight
    start_animation :fight, [@@image]
  end

  @@image = Image.load('./img/bullet.png')
  @@exit_image = Image.load_tiles("./img/pipo-btleffect008.png", 8, 1)
  def init
    self.collision = [ 0, 0, 11 ]
    self.animation_image = [@@image]
  end

  # 敵と弾が光ったら鬱陶しいか？
=begin
  def hit(other)
    self.fighting = false
    start_animation :exit, @@exit_image
  end
=end
  def out(other=nil)
    self.fighting = false
    start_animation :exit, @@exit_image
  end
end
