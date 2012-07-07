require './src/stdlib'
require './src/active_object/active_object'


class Player < ActiveObject
  attr_reader :life

  def initialize(point, bullets)
    super point, Vector2.new(0, 0)

    @life = $conf[:player_init_life]
    @direc = Vector2.new 0, 1

    @bullets = bullets
    @bullet_velocity = 5

    @collisions << CollisionCircle.new( self, 15, 30, 15 )
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
  end

  def fire
    direc = @velocity.dup; direc.size = 1

    @direc = direc if direc.size != 0

    nomal_fire if Input.key_down? K_Z
    spiral_fire if Input.key_down? K_X
  end

  def nomal_fire
    @bullets << Bullet.new( @point, @direc * @bullet_velocity)
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

    @collisions << CollisionCircle.new(self, 22, 22, 22)
  end

  def move
    @point += @velocity
  end
end
