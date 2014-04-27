# -*- coding: utf-8 -*-
require './dxruby/scene'


class RankingScene < Scene::Base
  def initialize(args = {})
    super args
  end

  def init(args)
    @hp = args[:life]
    @level = args[:level]

    @ranking = File.read("./data/ranking", encoding: Encoding::UTF_8).split("\n")

    @ranking << "LV " + (@level+1).to_s if @level
    @ranking << "HP " + @hp.to_s if @hp

    @ranking.sort!{ |a, b| (a[0] == b[0] ? b[3..-1].to_i <=> a[3..-1].to_i : (a[0] == "H" ? -1 : 1)) }

    @angle = 0

    @@bgm.play
  end

  def quit
    File.open("./data/ranking", "w"){ |f| f.write @ranking.join("\n") }

    @@bgm.stop
  end

  def update
    @next_scene =
      SelectScene.new if Input.key_push?(K_Z) or Input.key_push?(K_RETURN)

    @angle += 0.05
  end

  @@bgm = Sound.new('./snd/ranking.wav'); @@bgm.loop_count = -1
  @@font = Font.new 25
  @@background_image = Image.load('./img/play_background.png')
  @@waku = Image.new(270,27).roundbox_fill(0, 0, 250, 27, 10, [0, 10, 100])
  @@enemies_image = [Image.load('./img/red_enemy.png'),
                     Image.load('./img/blue_enemy.png'),
                     Image.load('./img/yellow_enemy.png'),
                     Image.load('./img/green_enemy.png')]
  def render
    @ranking.take(14).each_with_index do |r, i|
      Window.draw_font_ex(80, 30+i*30, (i+1).to_s, @@font,
                          z: 100, shadow: true, color: [255, 255, 100], alpha: 200)

      color = (r[0] == "L" ? [102, 255, 0] : [255, 0, 51])
      Window.draw_font_ex(200, 30+i*30, r, @@font,
                          z: 100, shadow: true, color: color, alpha: 200)
      Window.draw_ex(70, 29+i*30, @@waku, z: 10, alpha: 100)
    end

    4.times do |i|
      ang = @angle + i * Math.PI / 2
      option = { z: 50, alpha: 225 }
      x = 480+Math.cos(ang)*100; y = 120+Math.cos(ang)*100
      Window.draw_ex(x, y, @@enemies_image[i], option)
    end

    Window.draw_font_ex(420, 420, "Your score: HP "+@hp.to_s, @@font,
                        z: 100, shadow: true,
                        color: [255, 0, 51], alpha: 200) if @hp

    Window.draw_font_ex(420, 420, "Your score: LV "+(@level+1).to_s, @@font,
                        z: 100, shadow: true,
                        color: [102, 255, 0], alpha: 200) if @level

    Window.draw_font_ex(460, 450, "Press Z-key", @@font, z: 100, shadow: true,
                        color: [0, 102, 255], alpha: elap_time%1*200)

    Window.draw_ex(380, 419, @@waku, z: 50, alpha: 100) if @hp or @level
    Window.draw 0, 0, @@background_image
  end
end
