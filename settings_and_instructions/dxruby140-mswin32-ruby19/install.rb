#!ruby -Ks
# 簡易インストーラ

require 'rbconfig'
require 'fileutils'
include RbConfig

if CONFIG["ruby_version"] != "1.9.1" then
  puts "1.9.1以降じゃないと動かせません"
  exit
end

FileUtils.mkdir_p(CONFIG["sitearchdir"])
file = CONFIG["sitearchdir"] + "/" + "dxruby.so"
FileUtils.install("dxruby.so" , file, :preserve => true)
file = CONFIG["sitearchdir"] + "/" + "dxrubyex.so"
FileUtils.install("dxrubyex.so" , file, :preserve => true)

puts "DXRubyのインストールに成功しました"

require 'dxruby'

hlsl = <<EOS
float g_start;
float g_level;
texture tex0;
sampler Samp = sampler_state
{
 Texture =<tex0>;
 AddressU = CLAMP;
 AddressV = CLAMP;
};

struct PixelIn
{
  float2 UV : TEXCOORD0;
};
struct PixelOut
{
  float4 Color : COLOR0;
};

PixelOut PS(PixelIn input)
{
  PixelOut output;
  input.UV.x = input.UV.x + sin(radians(input.UV.y*360-g_start))*g_level;
  output.Color = tex2D( Samp, input.UV );

  return output;
}

technique Raster
{
 pass P0
 {
  PixelShader = compile ps_2_0 PS();
 }
}
EOS

core = Shader::Core.new(
  hlsl,
  {
    :g_start => :float,
    :g_level => :float,
  }
)

shader = Shader.new(core, "Raster")
image = Image.load('logo.png')
rt = RenderTarget.new(Window.width, image.height, [255,255,255])

Window.bgcolor=[255,255,255]
Window.create

x = Window.width / 2 - image.width / 2
y = Window.height / 2 - image.height / 2

(1..100).each do |z|
  break if Input.update
  break if Input.key_push?(K_ESCAPE)
  Window.draw_ex(x, y, image, :scalex=>(100.0 / z), :scaley=>(100.0 / z), :angle=>-(z-100)*5)
  Window.update
  Window.sync
end

20.times do |t|
  break if Input.update
  break if Input.key_push?(K_ESCAPE)
  Window.draw(x, y, image)
  Window.update
  Window.sync
end

start = 0.0
level = 0.0
60.times do |t|
  break if Input.update
  break if Input.key_push?(K_ESCAPE)
  rt.draw(x, 0, image)
  rt.update
  start += 10
  if t < 30 then level += 0.003 else level -= 0.003 end
  shader.g_start = start
  shader.g_level = level
  Window.draw_ex(0, y, rt, :shader=>shader, :blend=>:none)
  Window.update
  Window.sync
end

20.times do |t|
  break if Input.update
  break if Input.key_push?(K_ESCAPE)
  Window.draw(x, y, image)
  Window.update
  Window.sync
end

font = Font.new(48)
(0..63).each do |i|
  break if Input.update
  break if Input.key_push?(K_ESCAPE)
  Window.draw(x, y, image)
  Window.draw_font_ex(100, 380, "Installation completed.", font, :color=>[0,0,0], :edge_color=>[0,0,255], :edge=>true, :alpha=>i*4+3)
  Window.update
  Window.sync
end

keys = Input.keys
loop do
  break if Input.update
  break if Input.keys != keys
  Window.draw(x, y, image)
  Window.draw_font_ex(100, 380, "Installation completed.", font, :color=>[0,0,0], :edge_color=>[0,0,255], :edge=>true)
  Window.update
  Window.sync
end


