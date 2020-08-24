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
    @xs = []
    layers.count.times do
      @xs << 0
    end
    self
  end

  def direction n
    @direction = n
    self
  end

  def render
    sprites = []
    @layers.each_with_index do |f, layer|
      break if @xs[layer].nil?
      @xs[layer] -= @speed * (layer + 1) * @direction
      x_coord = @xs[layer] % @w
      sprites << [
        [x_coord - (@w - 1), 0, @w, @h, f].sprite,
        [x_coord, 0, @w, @h, f].sprite,
        [x_coord + (@w - 1), 0, @w, @h, f].sprite,
      ]
    end
    sprites
  end
end
