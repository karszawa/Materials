#!ruby -Ks
# DXRubyExtension�T���v��
require "dxruby"
require "dxrubyex"
#require './hitrangeview' # �Փ˔���͈͕`�惉�C�u�����BHitRange.view(Collision�z��)�ŏՓ˔���͈͂����F�Ō�����B

# �Փ˔���z��
# �����ɔ���I�u�W�F�N�g��������������
$collisions = []

# �������̋��ʃN���X
class CollisionObject
  def initialize
    @x = rand(639-@image1.width)
    @y = rand(439-@image1.height)
    @hit = false
    @dx = (rand(4)*2-3)/2.0
    @dy = (rand(4)*2-3)/2.0
  end

  # �L�����ړ��Ɣ���z��ݒ�
  def update
    @x += @dx
    @y += @dy
    @dx = -@dx if @x <= 0 or @x >= 639-@image1.width
    @dy = -@dy if @y <= 0 or @y >= 479-@image1.height

    # set���\�b�h�Ŕ���I�u�W�F�N�g�̈ʒu���ړ�����
    @collision.set(@x, @y)
    # �z���push
    $collisions.push(@collision)
    @hit = false
  end

  def draw
    if @hit then
      Window.draw(@x, @y, @image2)
    else
      Window.draw(@x, @y, @image1)
    end
  end

  # �������Ă�����hit���Ă΂��
  def hit(d)
    @hit = true
  end
end

# ������
class Box < CollisionObject
  def initialize
    # �Փ˔���I�u�W�F�N�g�쐬�B
    # �������̃I�u�W�F�N�g��hit���\�b�h���Ă΂��B
    # ���ȍ~�̈����͔���͈͂̎w��B���_�̓L�����̍��W�B
    # set���\�b�h�ňړ������邩��A����͈͕͂ύX����K�v���Ȃ��B
    @collision = CollisionBox.new(self, 0, 0, 29, 29)
    @image1 = Image.new(30, 30, [255, 200, 0, 0])
    @image2 = Image.new(30, 30, [255, 200, 200, 200])
    super
  end
end

# �܂�
class Circle < CollisionObject
  def initialize
    # �~�̏ꍇ�͒��S���W�Ɣ��a���w�肷��B
    @collision = CollisionCircle.new(self, 20, 20, 20)
    @image1 = Image.new(41, 41).circleFill(20, 20, 20, [255, 0, 0, 200])
    @image2 = Image.new(41, 41).circleFill(20, 20, 20, [255, 200, 200, 200])
    super
  end
end

# ���񂩂�
class Triangle < CollisionObject
  def initialize
    # �O�p��3�_�̍��W���w�肷��B
    @collision = CollisionTriangle.new(self, 20,0,0,39,39,39)
    @image1 = Image.new(40, 40)
    @image2 = Image.new(40, 40)
    for i in 0..39
      @image1.line(20-i/2, i, 20+i/2, i, [255,0,200,0])
      @image2.line(20-i/2, i, 20+i/2, i, [255,200,200,200])
    end
    super
  end
end

font = Font.new(24)

# �ړ����`�悷�郂�m�̔z��B20�����B
object = Array.new(30) {Box.new} +
         Array.new(30) {Circle.new} +
         Array.new(30) {Triangle.new}

# ���C�����[�v
Window.loop do
  # �ړ�������I�u�W�F�N�g�̔z��ւ�push
  object.each do |o|
    o.update
  end

  # �}�E�X�J�[�\���̍��W���Z�b�g�����_����I�u�W�F�N�g�B
  # ��������nil���w�肷��ƏՓ˒ʒm���s���Ȃ��B
  mousecollision = CollisionPoint.new(nil)
  mousecollision.set(Input.mousePosX, Input.mousePosY)

  # �}�E�X�J�[�\���ƃI�u�W�F�N�g�̏Փ˔���B
  # �P�̂̏ꍇ�͔z��ł���K�v�͂Ȃ��B
  Collision.check(mousecollision, $collisions)

  # �I�u�W�F�N�g���m�̏Փ˔���B
  Collision.check($collisions, $collisions)

  # �Փ˔���͈͂̉���
#  HitRange.view($collisions)

  # ����z����N���A����B
  $collisions.clear

  # �`��
  object.each do |o|
    o.draw
  end

  break if Input.keyPush?(K_ESCAPE)

  Window.drawFont(0, 0, Window.fps.to_s + " fps", font)
  Window.drawFont(0, 24, Window.getLoad.to_i.to_s + " %", font)
end