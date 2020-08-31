$gtk.reset

require 'lib/window.rb'

class Parallax
  # singleton pattern
  def self.create *args
    @@instance ||= self.new *args
    @@instance
  end

  def initialize w: 1280, h: 720, layers: [], speed: 1.2, direction: 1
    @w = w
    @h = h
    @layers = layers
    @speed = speed
    @direction = direction
    @sprites = []
    @xs = []
    layers.count.times do |i|
      @xs << 0
      3.times do
        @sprites << {x: 0, y: 0, w: @w, h: @h, path: layers[i]}.sprite
      end
    end
    self
  end

  def direction n
    @direction = n
    self
  end

  def speed n
    @speed = n
    self
  end

  def update
    @layers.count.times do |i|
      @xs[i] -= @speed * (i+1) * @direction
      x_coord = @xs[i] % @w
      @sprites[i*3+0][:x] = x_coord - (@w - 1)
      @sprites[i*3+1][:x] = x_coord
      @sprites[i*3+2][:x] = x_coord + (@w - 1)
    end
    self
  end

  def render_into win
    Window.render_into win, @sprites
    self
  end
end
