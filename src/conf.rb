require 'dxruby'
require 'dxrubyex'
require './src/stdlib'

$conf = {}

$conf[:debug] = true

$conf[:move_area_min] = Point.new 10, 10
$conf[:move_area_max] = Point.new 1890, 1410

$conf[:move_area_col] = [ Point.new(10, 10, 1890, 10),
                          Point.new(10, 10, 10, 1410),
                          Point.new(10, 1410, 1890, 1410),
                          Point.new(1890, 10, 1890, 1410) ]

$conf[:player_init_x] = 50
$conf[:player_init_y] = 50

$conf[:show_area_center] = Point.new 320, 240
$conf[:camera_point] = Point.new $conf[:player_init_x], $conf[:player_init_y]

$conf[:player_init_life] = 1000
$conf[:player_vel_limit] = 8

$conf[:max_divid_wall] = 16



