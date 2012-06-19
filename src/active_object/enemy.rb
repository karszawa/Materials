# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Enemy < ActiveObject
  def initialize(point, velocity, difficulty)
    super point, velocity

    @difficulty = difficulty
  end
end

# 鈍速、巨大
class RedEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty *3 ), difficulty

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

    @max_angle = 0.40
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
