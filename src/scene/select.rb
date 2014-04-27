# -*- coding: utf-8 -*-
require 'dxruby'
require 'pry' if $conf.debug
require './dxruby/scene'


class SelectScene < Scene::Base
  def init
    @now_choice = 0
    @choices_list = %w[ Play Ranking ]
    @scene_list = [ PlayScene, RankingScene ]
    @weight = 0.2
    @free_time = Time.now - @weight
    @time = 0
    @frame = 0

    @points = Array.new(4) do |i|
      p = Point.new(-20-100*i, 180)

      def p.update(id, time)
        first_step = 1.0+id/5.0
        second_step = 120*Math.PI/500
        third_step = 400.0 / 500.0

        if time < first_step
          self.x = 500*time-20-100*id
        elsif time < first_step + second_step
          ratio = (time - first_step) / second_step
          self.x = 480 + Math.sin(Math.PI*ratio)*120
          self.y = 300 - Math.cos(Math.PI*ratio)*120
        elsif time < 1.0 + second_step + third_step
          self.x = 480 - (time - first_step - second_step) * 500
        end

        if 8 < time
          t = time - 8
          iid = (t / 4).floor % 4
          it = (t % 4)

          if id == iid
            self.y = 420-it*100 if it < 0.5
            self.y = 420-(4.0-it)*100 if 3.5 < it
          end
        end
      end

      p
    end

    @@bgm.play
  end

  def quit
    @@bgm.stop
  end

  def update
    if @free_time < Time.now and Input.x != 0 then
      @free_time = Time.now + @weight
      @now_choice = (@now_choice + Input.x) % @choices_list.size
    end

    if Input.key_push?(K_RETURN) or Input.key_push?(K_Z)
      @next_scene = @scene_list[@now_choice].new
    end

    4.times{ |i| @points[i].update(i, self.elap_time) }
  end

  @@bgm = Sound.new('./snd/select.wav'); @@bgm.loop_count = -1
  @@font = Font.new 30
  @@bg = Image.load("./img/play_background.png")
  @@enemy_img =
    [
     Image.load("./img/red_enemy.png"), Image.load("./img/blue_enemy.png"),
     Image.load("./img/yellow_enemy.png"), Image.load("./img/green_enemy.png")
    ]
  @@enemy_color = [[255, 0, 51], [0, 102, 255], [255, 255, 0], [102, 255, 0]]
  @@enemy_info =
    [
     "・赤色\n・大型\n・鈍足\n・どこからでも追いかけてくる",
     "・青色\n・小型\n・速い\n・どこからでも追いかけてくる",
     "・黄色\n・中型\n・番兵\n・発見されると追いかけてくる",
     "・緑色\n・中型\n・巡回\n・発見されると追いかけてくる"
    ]

  def render
    # 選択肢
    @choices_list.each_with_index do |name, idx|
      alpha = (@now_choice == idx ? 200 : 50)
      alpha *= self.elap_time if self.elap_time < 1
      option = { z:1000, color:[255, 0, 102], alpha:alpha, shadow:true }
      Window.draw_font_ex(370+100*idx, 50, name, @@font, option)
    end

    # 敵ビュー
    @points.each_with_index do |p, i|
      x = p.x - @@enemy_img[i].width / 2
      y = p.y - @@enemy_img[i].height / 2
      Window.draw_alpha(x, y, @@enemy_img[i], 230, 100)
    end

    # 敵解説
    if 6 < self.elap_time
      t = self.elap_time - 6

      alpha = 200
      alpha *= (t-0.25)*4 if t < 0.25

      option = { z:1000, color:[10,255,255], alpha:alpha, shadow:true }
      Window.draw_font_ex(50, 140, "主要敵情報", @@font, option)
    end

    if 8 < self.elap_time
      t = self.elap_time - 8
      id = (t / 4).floor % 4
      it = (t % 4)

      alpha = 200
      alpha *= it * 2 if it < 0.5
      alpha *= (4-it) * 2 if 3.5 < it

      option = { z:1000, color:@@enemy_color[id], alpha:alpha, shadow:true }
      @@enemy_info[id].split("\n").each_with_index do |s, i|
        Window.draw_font_ex(50, 200+i*30, s, @@font, option)
      end
    end

    # 背景ドーン
    Window.draw(0, 0, @@bg)
  end
end
