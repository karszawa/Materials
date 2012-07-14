require 'dxruby'
require 'dxrubyex'
require './src/stdlib'

$conf = {}

$conf[:debug] = true

$conf[:move_area_min] = Point.new 10, 10
$conf[:move_area_max] = Point.new 1890, 1410

$conf[:move_area_col] = [Sprite.new(10, 10, Image.new(1880, 1)),
                         Sprite.new(10, 10, Image.new(1, 1400)),
                         Sprite.new(10, 1410, Image.new(1880, 1)),
                         Sprite.new(1890, 10, Image.new(1, 1400))]

$conf[:player_init_point] = Point.new 50, 50

$conf[:show_area_center] = Point.new 320, 240
$conf[:camera_point] = Point.new $conf[:player_init_x], $conf[:player_init_y]

$conf[:player_init_life] = 1000
$conf[:player_vel_limit] = 8

$conf[:max_divid_wall] = 16

$conf[:enem_depth] = 100


