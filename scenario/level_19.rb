75.times do |i|
  arg = i / 75.0 * 2 * Math.PI
  r = 500

  x = r * Math.cos(arg)
  y = r * Math.sin(arg)

  Red 0.015, x, y, 0.1, follow: true, silver: true
end

25.times do |i|
  point_x = rand 2000
  point_y = rand 1500
  Green 0.2 * i, point_x, point_y, 0.5
end

Red 10, *($conf.active_field/2).to_a, 0.5, silver: true
