# -*- coding: utf-8 -*-
require './stdlib'
require './conf.rb'

include Conf


class ActiveObject
  def initialize(point, velocity)
    @point = point; @velocity = velocity

    @state = :arrive
    @start_time = Time.now
    @arrive_time = 1
  end

  def update
    @state = :active if @state != :active && @arrive_time < Time.now - @start_time

    if @state == :active then
      move
      fire
    end
  end

  def move; end
  def fire; end

  # trueを返すならオブジェクトは死亡
  def hit
    @state = :dead
    true
  end
end


class Player < ActiveObject
  def initialize(point)
    super point, Vector2.new(0, 0)

    @life = 1000

    @player_vel_lim = 10
  end

  def update
    super

    $player_point_x = @x
    $player_point_y = @y
  end

  def move
    @velocity = (@velocity + Input);
    @velocity.size = min @velocity.size, @player_vel_lim

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

