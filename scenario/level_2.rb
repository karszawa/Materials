
# 20.times{|x| 5.times{|y| Red 1, 500 + x * 70, 500 + y * 70, 0.7 } }

base_x = $conf.active_field.x / 2
base_y = $conf.active_field.y / 2

r = 1
theta = 0

500.times do |i|
  Green 0, base_x + r * Math.cos(theta), base_y + r * Math.sin(theta), 0.5;
  r += 4
  theta += 0.05
end



=begin
hogehoge
hogege
=end
