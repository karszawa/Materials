require 'dxruby'
require 'dxrubyex'
require './src/stdlib'
require 'ostruct'

$conf = OpenStruct.new

$conf.debug = true

$conf.move_area_min = Point.new(10, 10)
$conf.move_area_max = Point.new(1890, 1410)

$conf.move_area_col = [Sprite.new(10, -90, Image.new(1980, 100)),
                       Sprite.new(-90, -90, Image.new(100, 1500)),
                       Sprite.new(-90, 1400, Image.new(1980, 100)),
                       Sprite.new(1880, 10, Image.new(100, 1500))]

$conf.player_init_point = Point.new(50)

$conf.show_area_center = Point.new(320, 240)
$conf.camera_point = Point.new($conf.player_init_x, $conf.player_init_y)

$conf.player_init_life = 1000
$conf.player_vel_limit = 8

$conf.max_divid_wall = 16

$conf.enem_depth = 100


