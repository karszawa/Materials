# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Enemy < ActiveObject
  def initialize(point, velocity, difficulty)
    super point, velocity

    @difficulty = difficulty
  end

  def fallow_player
    origin_angle = Math.atan2 *@velocity.to_a.reverse
    target_angle = Math.atan2 *($player_pnt - @point).to_a.reverse

    next_angle = range -@max_flw_ang, target_angle - origin_angle, @max_flw_ang

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
    @max_flw_ang = difficulty / 3 + 0.3
  end

  def move
    self.fallow_player
  end


  @@image = Image.load('./img/red_enemy.png')
  def init
    self.collision = [ 22, 22, 22 ]
    self.image = @@image
  end
end


# 俊敏、小型
# プレイヤーを追う。
# 小さくて速い。
class BlueEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 4.5 ), difficulty
    @max_flw_ang = 0.40
  end

  def move
    self.fallow_player
  end


  @@image = Image.load('./img/blue_enemy.png')
  def init
    self.collision = [14, 14, 14]
    self.image = @@image
  end
end


# 番兵、中型
# 円形の縄張りを持ち、その円周上を周回する。
# 観測半径内にプレイヤーを発見したらプレイヤーを追うようになる。
class YellowEnemy < Enemy
  # point は巡回円の中心とする
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 4 ), difficulty

    @look_center = point

    @look_angle = 0.0
    @look_ang_vel = 0.01
    @look_rad = 80 * difficulty + 150
    @move_rad = 100 * difficulty + 50
    @find_flag = false

    @rot_vel = 1.0
    @max_flw_ang = 0.4

    self.angle = rand 360
    self.x += @move_rad
  end

  def move
    self.angle += @rot_vel

    if @find_flag then
      self.fallow_player
    else
      @look_angle += @look_ang_vel
      @point = @look_center + Point.polar(@look_angle, @move_rad)

      @find_flag = (@point - $player_pnt).size <= @look_rad
    end
  end


  @@image = Image.load('./img/yellow_enemy.png')
  def init
    self.collision = [ 0, 0, 35, 35 ]
    self.image = @@image
  end
end


# 遊撃、小型
# ランダムな点を選び、そこに向かう。到着したら次の点を選び底に向かう。
# 観測半径内にプレイヤーを発見したらプレイヤーを追うようになる。
class GreenEnemy < Enemy
  def initialize(point, difficulty)
    super point, Vector2.new( difficulty * 6 ), difficulty

    @arv_rad = 50 # 次のランダム目的地への到着判定半径
    @look_rad = 100 * difficulty + 50 # プレイヤー発見半径
    @find_flag = false
    @max_flw_ang = 0.4

    @rot_vel = 1

    self.angle = rand 360
    self.set_next
  end

  def move
    self.angle += @rot_vel

    if @find_flag then
      self.fallow_player
    else
      @point += @velocity

      self.set_next if (@point - @next_point).size < @arv_rad

      @find_flag = (@point - $player_pnt).size < @look_rad
      @velocity *= 0.8 if @find_flag
    end
  end

  # 次に向かうポイントを設定し、それに従って速度も設定する
  def set_next
    @next_point = rand_point

    size = @velocity.size
    @velocity = @next_point - @point
    @velocity.size = size
  end

  def rand_point
    rect = $conf.move_area_max - $conf.move_area_min
    x = rand(rect.x) + $conf.move_area_min.x
    y = rand(rect.y) + $conf.move_area_min.y
    Point.new x, y
  end


  @@image = Image.load('./img/green_enemy.png')
  def init
    self.collision = [ 15, 0, 0, 32, 25, 52 ]
    self.image = @@image
  end
end
