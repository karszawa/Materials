require './src/stdlib'

module Conf
  @@conf = {}

  @@conf[:move_area_min] = Point.new 10, 10
  @@conf[:move_area_max] = Point.new 610, 450

  @@conf[:player_init_x] = 50
  @@conf[:player_init_y] = 50

  @@conf[:player_init_life] = 1000
  @@conf[:player_vel_limit] = 8
end
