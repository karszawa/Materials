base_x = $conf.active_field.x / 2
base_y = $conf.active_field.y / 2

r = 1
theta = 0

250.times do |i|
  Green 0, base_x + r * Math.cos(theta), base_y + r * Math.sin(theta), 0.5, silver: (rand < 0.01)
  r += 4
  theta += 0.05
end
