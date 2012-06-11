# -*- coding: utf-8 -*-
require 'dxrubyex'
require './stdlib'
require './conf.rb'

include Conf


class ActiveObject
  attr_reader :life, :collisions

  def initialize(point, velocity)
    @point = point; @velocity = velocity

    @life = 0
    @collisions = []

    @state = :apper
    @start_time = Time.now
    @arrive_time = 1
  end

  def update
    @state = :active if @state != :active && @arrive_time < Time.now - @start_time

    if @state == :active then
      move
      fire
    end

    collision.each { |obj| obj.set @point.x, @point.y }
  end

  def move; end
  def fire; end

  def hit
    @state = :dead
  end
end


class Player < ActiveObject
  attr_reader :life

  def initialize(point, bullets)
    super point, Vector2.new(0, 0)

    @life = @@conf[:player_init_life]

    @bullets = bullets

    @collisions << CollisionTriangle.new self, 0, 20, 4.5, 0, -4.5, 0
  end

  def update
    super

    $player_point_x = @x
    $player_point_y = @y
  end

  def move
    @velocity += Input
    @velocity.size = min @velocity.size, @@conf[:player_vel_limit]

    next_point = @point + @velocity
    min = @@conf[:move_area_min]; max = @@conf[:move_area_max]
    @point =  Vector2.catch min, next_point, max
  end

  def fire
  end

  def hit
    @life -= 1
  end
end


class Bullet < ActiveObject
  def initialize(point, velocity)
    super point, velocity
  end
end


class Enemy < ActiveObject
  def initialize(point, velocity)
    super point, velocity
  end
end


class RedEnemy < Enemy
  def initialize(point, velocity)
    super point, velocity
  end
end


class YellowEnemy < Enemy
  def initialize(point, velocity)
    super point, velocity
  end
end

