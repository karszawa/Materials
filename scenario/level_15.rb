30.times do|i|
  point_x = rand 1950
  point_y = rand 1450
  Red i, point_x, point_y, 0.8, silver:true
  Blue i, point_x, point_y, 0.8, silver:true
  Green i, point_x, point_y, 0.8, silver:true
end

point_x = rand 1500
point_y = rand 1000
Yellow 35, point_x + 300, point_y + 250, 0.1