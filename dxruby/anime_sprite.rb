class AnimeSprite < Sprite
  def initialize(x=0, y=0, z=0, image=nil)
    super
    self.x = x
    self.y = y
    self.z = z
    self.animation_image = image if image
    @anime_sprite_count = 0
    @anime_sprite_frame_count = 1
    @anime_sprite_pause = true
    @anime_sprite_animation_pattern = nil
    @anime_sprite_hash = {}
    @anime_sprite_next = nil
  end

  def start_animation(v, animation_pattern=nil, nxt=nil)
    temp = @anime_sprite_hash[v]
    if temp
      @anime_sprite_frame_count = temp[0]
      @anime_sprite_animation_pattern = temp[1]
      @anime_sprite_next = temp[2]
    else
      @anime_sprite_frame_count = v
      @anime_sprite_animation_pattern = animation_pattern
      @anime_sprite_next = nxt
    end
    @anime_sprite_pause = false
    @anime_sprite_count = 0

    self
  end

  def change_animation(v, animation_pattern=nil, nxt=nil)
    temp = @anime_sprite_hash[v]
    if temp
      @anime_sprite_frame_count = temp[0]
      @anime_sprite_animation_pattern = temp[1]
      @anime_sprite_next = temp[2]
    else
      @anime_sprite_frame_count = v
      @anime_sprite_animation_pattern = animation_pattern
      @anime_sprite_next = nxt
    end

    self
  end

  def pause_animation
    @anime_sprite_pause = true
  end

  def resume_animation
    @anime_sprite_pause = false
  end

  def add_animation(v, frame_count, animation_pattern=nil, nxt=nil)
    @anime_sprite_hash[v] = [frame_count, animation_pattern, nxt]
  end

  def update
    if @anime_sprite_animation_pattern
      unless @anime_sprite_pause
        @anime_sprite_count += 1
        if @anime_sprite_count >= @anime_sprite_frame_count * @anime_sprite_animation_pattern.size
          if @anime_sprite_next
            temp = @anime_sprite_hash[@anime_sprite_next]
            if temp
              @anime_sprite_frame_count = temp[0]
              @anime_sprite_animation_pattern = temp[1]
              @anime_sprite_next = temp[2]
            else
              self.send @anime_sprite_next
            end
          end
          @anime_sprite_count = 0
        end
      end
      self.image = @anime_sprite_animation_image[@anime_sprite_animation_pattern[@anime_sprite_count / @anime_sprite_frame_count]]
    else
      unless @anime_sprite_pause
        @anime_sprite_count += 1
        if @anime_sprite_count >= @anime_sprite_frame_count * @anime_sprite_animation_image.size
          if @anime_sprite_next
            temp = @anime_sprite_hash[@anime_sprite_next]
            if temp
              @anime_sprite_frame_count = temp[0]
              @anime_sprite_animation_pattern = temp[1]
              @anime_sprite_next = temp[2]
            else
              self.send @anime_sprite_next
            end
          end
          @anime_sprite_count = 0
        end
      end
    self.image = @anime_sprite_animation_image[@anime_sprite_count / @anime_sprite_frame_count]
    end
    super
  end

  def animation_image
    @anime_sprite_animation_image
  end

  def animation_image=(v)
    @anime_sprite_animation_image = v
    self.image = v[0]
  end
end
