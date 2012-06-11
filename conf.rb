require './stdlib'

module Conf
  @@conf = {}

  @@conf[:move_area_min] = Point.new 10, 10
  @@conf[:move_area_max] = Point.new 630, 470
end
