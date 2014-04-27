75.times do |i|
  arg = i / 75.0 * 2 * Math.PI
  r = 500

  x = r * Math.cos(arg)
  y = r * Math.sin(arg)


  Red 0.015*i, x, y, 0.1, follow:true, silver:true
end

100.times do |i|
  arg = i / 100.0 * 2 * Math.PI
  r = 550

  x = r * -Math.cos(arg)
  y = r * -Math.sin(arg)

  Red 0.0125*i, x, y, 0.1, follow: true, silver: true
end

Yellow 15, 50,50, 0.1, follow:true
