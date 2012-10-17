
5.times do
  base_point = $conf.rand_point
  r = 100

  20.times do |i|
    obj_x = base_point[0] + Math.cos(i * 36 / 360.0 * Math.PI) * r
    obj_y = base_point[1] + Math.sin(i * 36 / 360.0 * Math.PI) * r

    Yellow 1, obj_x, obj_y, 1
  end
end


