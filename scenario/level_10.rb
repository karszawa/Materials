3.times do
  point_x = rand 2000
  point_y = rand 1500
  Red 0, point_x, point_y, 0.6, silver:true
  Blue 0, point_x, point_y, 0.6, silver:true
  Green 0, point_x, point_y, 0.6, silver:true
  Yellow 0, point_x, point_y, 0.6, silver:true
end


30.times do
  point_x = rand 2000
  point_y = rand 1500
  Yellow 0, point_x, point_y, 0.8
end
