# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Enemy < ActiveObject
  def initialize(point, velocity, difficulty)
    super point, velocity

    @difficulty = difficulty

    add_animation :advent, 1, (0..13).to_a, :to_fight_mode
    add_animation :exit, 1, (0..7).to_a, :vanish
    add_animation :fight, 1, [0], :fight

    self.fighting = false
    start_animation :advent, @@advent_image
  end

  def fallow_player
    origin_angle = Math.atan2 *@velocity.to_a.reverse
    target_angle = Math.atan2 *($player_pnt - @point).to_a.reverse

    next_angle = range -@max_flw_ang, target_angle - origin_angle, @max_flw_ang

    # 慣性が働くようにしている
    next_vel = @velocity + @velocity.rotate(next_angle)
    next_vel.size = @velocity.size

    @point += (@velocity = next_vel)
  end

  def hit(other)
    self.fighting = false
    start_animation :exit, @@exit_image
  end

  @@advent_image = Image.load_tiles("./img/pipo-btleffect007.png", 14, 1)
  @@exit_image = Image.load_tiles("./img/pipo-btleffect008.png", 8, 1)
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
    @width = 44; @height = 44;
  end

  def to_fight_mode
    self.fighting = true
    start_animation :fight, [@@image]
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
    @width = 28; @height = 28;
  end

  def to_fight_mode
    self.fighting = true
    start_animation :fight, [@@image]
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
    self.collision = [ 0, 0, 34, 34 ]
    self.image = @@image
    @width = 34; @height = 34;
  end

  def to_fight_mode
    self.fighting = true
    start_animation :fight, [@@image]
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
    x = rand($conf.active_field.x)
    y = rand($conf.active_field.y)
    Point.new x, y
  end

  @@image = Image.load('./img/green_enemy.png')
  def init
    self.collision = [14, 0, 0, 32, 25, 52]
    self.image = @@image
    @width = 52; @height = 52;
  end


  def to_fight_mode
    self.fighting = true
    start_animation :fight, [@@image]
  end
end
