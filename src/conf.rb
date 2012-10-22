require 'dxruby'
require 'dxrubyex'
require './src/stdlib'
require 'ostruct'

$conf = OpenStruct.new

$conf.debug = true

$conf.active_field = Point.new(1920, 1440)

$conf.divid_line =
  [
   Sprite.new(0,-100, Image.new($conf.active_field.x+100, 100)),
   Sprite.new(-100,-100, Image.new(100, $conf.active_field.y+100)),
   Sprite.new($conf.active_field.x,0, Image.new(100, $conf.active_field.y+100)),
   Sprite.new(-100,$conf.active_field.y, Image.new($conf.active_field.x+100, 100))
  ]


$conf.player_init_point = Point.new(320, 240)

$conf.window_size = Vector2.new(640, 480)
$conf.show_area_center = $conf.window_size / 2

$conf.enem_depth = 100



def $conf.rand_point
  [rand($conf.active_field.x), rand($conf.active_field.y)]
end
