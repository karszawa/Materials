require './src/stdlib'

require './src/active_object/active_object'


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
  end

  def move
    @point += @velocity
  end
end
