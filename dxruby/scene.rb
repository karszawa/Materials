# -*- coding: utf-8 -*-
# MyGameのscene.rbをMyGameに依存しないように切り離した汎用sceneモジュール。
# でもDXRuby専用です。
require 'dxruby'

module Scene
  class Exit; end

  class Base
    attr_accessor :next_scene
    attr_reader :frame_counter

    def initialize(hash = nil)
      @next_scene = nil
      @frame_counter = 0

      init hash if hash
      init unless hash

      @start_time = Time.now
    end

    def __update
      @frame_counter += 1
      update
    end
    private :__update

    def init; end

    def quit; end

    def update; end

    def render; end

    def elap_time; Time.now - @start_time; end
  end

  def self.main_loop(first_scene, fps = 60, step = 1)
    scene = first_scene
    default_step = step

    Window.loop do
      if Input.key_push?(K_PGDN)
        step += 1
        Window.fps = fps * default_step / step
      end

      if Input.key_push?(K_PGUP) and step > default_step
        step -= 1
        Window.fps = fps * default_step / step
      end

      step.times do
        break if scene.next_scene
        scene.__send__ :__update
      end

      scene.render

      if scene.next_scene
        scene.quit
        break if Exit == scene.next_scene
        scene = scene.next_scene
      end
    end
  end
end
