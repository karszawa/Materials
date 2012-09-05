
base_x = 500
base_y = 500
r = 100

10.times do |i|
  obj_x = base_x + Math.cos(i * 36 / 360.0 * Math.PI) * r
  obj_y = base_y + Math.sin(i * 36 / 360.0 * Math.PI) * r

  Yellow 1, obj_x, obj_y, 1
end

