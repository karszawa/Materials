# -*- coding: utf-8 -*-
require 'dxruby'
require 'dxrubyex'

require './stdlib'
require './conf'

include Conf


class ActiveObject
  attr_reader :life, :collisions

  def initialize(point, velocity)
    @point = point; @velocity = velocity

    @life = 0
    @collisions = []

    @state = :apper
    @start_time = Time.now
    # @arrive_time = 1
    @arrive_time = 1
  end

  def update
    @state = :active if @state != :active && @arrive_time < Time.now - @start_time

    if @state == :active then
      move
      fire
      collisions.each { |obj| obj.set @point.x, @point.y }
    end
  end

  def move; end
  def fire; end

  def hit(other)
    @state = :dead
  end
end


class Player < ActiveObject
  attr_reader :life

  def initialize(point, bullets)
    super point, Vector2.new(0, 0)

    @life = @@conf[:player_init_life]
    @direc = Vector2.new 0, 1

    @bullets = bullets
    @bullet_velocity = 5

    @collisions << CollisionTriangle.new(self, 0, 20, 4.5, 0, -4.5, 0)
  end

  def update
    super

    $player_pnt = @point
  end

  def move
    @velocity += Input
    @velocity.size = min @velocity.size, @@conf[:player_vel_limit]

    next_point = @point + @velocity
    @velocity.size *= 0.94

    min = @@conf[:move_area_min]; max = @@conf[:move_area_max]
    @point =  Vector2.catch min, next_point, max
  end

  def fire
    direc = @velocity.dup; direc.size = 1

    @direc = direc if direc.size != 0

    nomal_fire if Input.keyPush? K_Z
    spiral_fire if Input.keyPush? K_X
  end

  def nomal_fire
    @bulllets << Bullet.new( point, @direc * @bullet_velocity)
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

    @arrive_time = 0
  end

  def move
    @point += @velocity
  end
end


class Enemy < ActiveObject
  def initialize(point, velocity, difficulty)
    super point, velocity

    @difficulty = difficulty
  end
end


# 鈍速、巨大
class RedEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new(1) * difficulty * 3, difficulty

    @max_angle = difficulty / 3 + 0.3
    @collisions << CollisionCircle.new( self, 11, 11, 22 )
  end

  def move
    origin_angle = Math.atan2 @velocity.y, @velocity.x
    target_angle = Math.atan2 $player_pnt.y - @point.y, $player_pnt.x - @point.x

    next_angle = range -@max_angle, target_angle - origin_angle, @max_angle

    @velocity.rotate! next_angle

    @point += @velocity
  end
end


# 俊敏、小型
class BlueEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty

    @max_range = 0.40
    @collisions << CollisionCircle.new( self, 5.5, 5.5, 11 )
  end

  def move
    origin_angle = Math.atan2 @velocity.y, @velocity.x
    target_angle = Math.atan2 $player_pnt.y - @point.y, $player_pnt.x - @point.x

    next_angle = range -@max_angle, target_angle - origin_angle, @max_angle

    @velocity.rotate! next_angle

    @point += @velocity
  end
end


# 変則、中型
class YellowEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty

    @collisions << CollisionCircle.new( self, 4, 4, 8 )
  end

  def move
  end
end


# 遊撃、小型
class GreenEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 7 ), difficulty

    @collisons << CollisionTriangle.new( self, 2, 2, 4 )
  end

  def move
  end
end
