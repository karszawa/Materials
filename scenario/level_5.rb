10.times do
  point_x = rand 2000
  point_y = rand 1500
  Red 0, point_x, point_y, 0.5
  Blue 0, point_x, point_y, 0.5
  Green 0, point_x, point_y, 0.5
  Yellow 0, point_x, point_y, 0.5
end

=begin
5.times do
  base_point = $conf.rand_point
  r = 100

  20.times do |i|
    obj_x = base_point[0] + Math.cos(i * 36 / 360.0 * Math.PI) * r
    obj_y = base_point[1] + Math.sin(i * 36 / 360.0 * Math.PI) * r

    Yellow 0, obj_x, obj_y, 1
  end
end


100.times do |i|
	Red 30, i * 20, 0, 0.8
end

75. times do |i|
	Yellow 30, 0, i * 20, 0.8
end

100.times do |i|
	Red 30, i * 20, 1500, 0.8
end

75.times do |i|
	Yellow 30, 2000, i * 20, 0.8
end
=end