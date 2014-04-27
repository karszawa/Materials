5.times do |t|
  10.times do |i|
    arg = i / 10.0 * 2 * Math.PI
    r = 500

    x = r * Math.cos(arg)
    y = r * Math.sin(arg)

    # メソッドの最後にfallow:trueを追加で、出現位置をプレイヤー基準にする。
    Red t * 2, x, y, 0.5 + t * 0.05, follow:true
  end
end

Blue 0, 0, 0, 0.8, silver:true
