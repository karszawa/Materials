require 'dxruby'

class Image
  def roundbox(x1, y1, x2, y2, r, c)
    image = Image.new(r * 2, r * 2).circle(r, r, r, c)
    self.draw(0, 0, image, 0, 0, r, r)
    self.draw(self.width - r, 0, image, r, 0, r, r)
    self.draw(0, self.height - r, image, 0, r, r, r)
    self.draw(self.width - r, self.height - r, image, r, r, r, r)
    self.line(r, 0, self.width - r, 0, c)
    self.line(self.width - 1, r, self.width - 1, self.height - r, c)
    self.line(self.width - r, self.height - 1, r, self.height - 1, c)
    self.line(0, r, 0, self.height - r, c)
  end

  def roundbox_fill(x1, y1, x2, y2, r, c)
    image = Image.new(r * 2, r * 2).circle_fill(r, r, r, c)
    self.draw(0, 0, image, 0, 0, r, r)
    self.draw(self.width - r, 0, image, r, 0, r, r)
    self.draw(0, self.height - r, image, 0, r, r, r)
    self.draw(self.width - r, self.height - r, image, r, r, r, r)
    self.box_fill(r, 0, self.width - r, self.height - 1, c)
    self.box_fill(0, r, self.width - 1, self.height - r, c)
  end
end
