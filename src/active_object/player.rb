# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Player < ActiveObject
  # 発射した弾丸をPlay#bulletsに渡すラムダを引数に持つ
  def initialize(shoot_bullet)
    super $conf.player_init_point, Vector2.new

    @life = 100
    @angle = Vector2.new(0, 1)
    @max_velocity = 8
    @bullet_velocity = 10
    @accel = 0.94
    @fire_weight = 0.05
    @spiral_base_ang = 0
    @normal_fire_time = Time.now - @fire_weight
    @spiral_fire_time = Time.now - @fire_weight

    @shoot_bullet = shoot_bullet

    $conf.draw_gap = $conf.show_area_center - @point

    add_animation :fight, 1, [0], :fight
    start_animation :fight
  end

  def move
    # velocity
    @velocity += Input
    @velocity.size = min(@velocity.size, @max_velocity / @accel)
    @velocity.size *= @accel

    # point
    @point += @velocity
    llimit = Point.new(self.image.width,self.image.height)*0.5
    ulimit = $conf.active_field - Point.new(self.image.width,self.image.height)*0.5
    @point = Point.catch(llimit, @point, ulimit)

    # angle
    angle = @velocity.dup; angle.size = 1
    @angle = angle if angle.size != 0
    self.angle = Math.atan2(@angle.y, @angle.x) / Math.PI * 180 + 90

    # outer settings
    $player_pnt = @point
    $conf.draw_gap = $conf.show_area_center - $player_pnt
    $conf.draw_gap.x = range(-1280, $conf.draw_gap.x, 0)
    $conf.draw_gap.y = range(-960, $conf.draw_gap.y, 0)
  end

  def fire
    self.normal_fire(Input.pad_rstick)
    self.spiral_fire if Input.key_down? K_X

    self.normal_fire(@angle.to_a) if Input.key_down? K_Z
  end

  def normal_fire(stick)
    if @normal_fire_time + @fire_weight <= Time.now and stick != [0, 0]
      @normal_fire_time = Time.now

      vec = Vector2.new(*stick)
      vec.size = 1.0
      ang = vec.arg

      position = @point + vec * 50
      dx, dy = @@image.width/2, @@image.height/2
      position.x += dx * Math.cos(ang) + dy * Math.sin(ang)
      position.y += dy * Math.cos(ang) - dx * Math.sin(ang)

      rd = (rand-0.5)*Math.PI/15
      @shoot_bullet.call(Bullet.new(position, vec.rotate(rd) * @bullet_velocity))
    end
  end

  def spiral_fire
    bullet_num = 20
    base_point = @point + Point.new(@@image.width / 2, @@image.height / 2)

    bullet_num.times do |i|
      angle = Vector2.polar(i * 2.0 * Math.PI / bullet_num + @spiral_base_ang, 1.0)
      point = base_point + angle * 50
      @shoot_bullet.call Bullet.new(point, angle * @bullet_velocity)
    end

    @spiral_base_ang += 10

    @life -= 1
    self.vanish if @life <= 0
  end

  def hit(other)
    @life -= 1

    self.vanish if @life <= 0
  end


  @@image = Image.load('./img/player.png')
  def init
    self.collision = [[18, 0, 0, 30, 36, 30], [18, 58, 19, 30, 28, 30]]
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
    self.collision = [ 11, 11, 11 ]
    self.animation_image = [@@image]
  end

  def out(other=nil)
    llimit = Point.new(self.image.width,self.image.height)*0.5
    ulimit = $conf.active_field - Point.new(self.image.width,self.image.height)*0.5
    @point = Point.catch(llimit, @point, ulimit)
    self.x = @point.x; self.y = @point.y

    self.fighting = false
    start_animation :exit, @@exit_image
  end
end
