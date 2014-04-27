
theta = 0
100.times do |i|
  x = 300*Math.cos(theta)
  y = 300*Math.sin(theta)
  Red 3+i*0.1, x, y, 0.8, follow: true, silver: (rand < 0.01)
  theta += 0.5
end
