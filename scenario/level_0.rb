# -*- coding: utf-8 -*-

time = 1
point_x = rand 1000
point_y = rand 500
difficulty = rand

Red time, point_x, point_y, difficulty
Blue time, point_x, point_y, difficulty
Green time, point_x, point_y, difficulty
Yellow time, point_x, point_y, difficulty

=begin
10.times { |i| Red i * 0.3 + 0, 20, 20, 1.0 }
10.times { |i| Red i * 0.3 + 3, 1880, 20, 1.0 }
10.times { |i| Red i * 0.3 + 6, 20, 1400, 1.0 }
10.times { |i| Red i * 0.3 + 9, 1880, 1400, 1.0 }


100.times do
  Blue 10, rand($conf.move_area_max.x), rand($conf.move_area_max.y), rand
  Green 25, rand($conf.move_area_max.x), rand($conf.move_area_max.y), rand
end
=end
