# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'
require './src/rotate_collisions'

class Enemy < ActiveObject
  def initialize(point, velocity, difficulty)
    super point, velocity

    @difficulty = difficulty
  end

  def fallow_player
    origin_angle = Math.atan2 @velocity.y, @velocity.x
    target_angle = Math.atan2 $player_pnt.y - @point.y, $player_pnt.x - @point.x

    next_angle = range -@max_angle, target_angle - origin_angle, @max_angle

    @velocity.rotate! next_angle

    @point += @velocity
  end
end

# 鈍速、巨大
# プレイヤーを追う。
# 大きくて遅い。
class RedEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty *3 ), difficulty
    @collisions << CollisionCircle.new( self, 22, 22, 22 )

    @max_angle = difficulty / 3 + 0.3
  end

  def move
    fallow_player
  end
end


# 俊敏、小型
# プレイヤーを追う。
# 小さくて速い。
class BlueEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty
    @collisions << CollisionCircle.new( self, 14, 14, 14 )
    @max_angle = 0.40
  end

  def move
    fallow_player
  end
end


# 番兵、中型
# 円形の縄張りを持ち、その円周上を周回する。
# 観測半径内にプレイヤーを発見したらプレイヤーを追うようになる。
class YellowEnemy < Enemy
  # point は巡回円の中心とする
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty
    @collisions << CollisionBox.new( self, 0, 0, 35, 35 )

    @center = point
    @move_rad = 100 * difficulty + 50
    @look_rad = 100 * difficulty + 50
    @angle = 0.0
    @ang_vel = 0.01
    @find_flag = false

    @rot_ang = 0.0
    @rot_vel = 1.0
    @max_angle = 0.4
  end

  def move
    @rot_ang += @rot_vel
    @rot_ang %= 360

    if @find_flag then
      fallow_player
    else
      @angle += @ang_vel
      @point = @center
      @point += Point.new( Math.cos(@angle), Math.sin(@angle) ) * @move_rad

      @find_flag = (@point - $player_pnt).size <= @look_rad
    end
  end
end


# 遊撃、小型
# ランダムな点を選び、そこに向かう。到着したら次の点を選び底に向かう。
# 観測半径内にプレイヤーを発見したらプレイヤーを追うようになる。
class GreenEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty
    @collisions << CollisionTriangle.new( self, 15, 0, 0, 32, 25, 52 )
    @arrive_rad = 50

    @look_rad = 100 * difficulty + 50
    @find_flag = false
    @max_angle = 0.4

    @rot_ang = 0
    @rot_vel = 1

    set_next
  end

  def move
    @rot_ang += @rot_vel
    @rot_ang %= 360

    if @find_flag then
      fallow_player
    else
      @point += @velocity

      set_next if (@point - @next_point).size < @arrive_rad

      @find_flag = (@point - $player_pnt).size < @look_rad
      @velocity *= 0.8 if @find_flag
    end

    @collisions[0].setex(*@point.to_a)
    @collisions[0].rotate(*(@point + @@img_size / 2).to_a, @rot_ang)
  end

  # 次に向かうポイントを設定し、それに従って速度も設定する
  def set_next
    @next_point = rand_point

    size = @velocity.size
    @velocity = @next_point - @point
    @velocity.size = size
  end

  def rand_point
    rect = $conf[:move_area_max] - $conf[:move_area_min]
    x = rand(rect.x) + $conf[:move_area_min].x
    y = rand(rect.y) + $conf[:move_area_min].y
    Point.new x, y
  end
end
