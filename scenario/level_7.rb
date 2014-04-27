40.times do
  point_x = rand 2000
  point_y = rand 1500
  Red 0, point_x, point_y, 0.9, silver: (rand < 0.01)
  Blue 0, point_x, point_y, 0.9, silver: (rand < 0.01)
  Green 0, point_x, point_y, 0.9, silver: (rand < 0.01)
  Yellow 0, point_x, point_y, 0.9, silver: (rand < 0.01)
end
