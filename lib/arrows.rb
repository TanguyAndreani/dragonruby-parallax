class Arrows
  SPRITE = 'assets/arrow.png'

  # singleton pattern
  def self.create *args
    @@instance ||= self.new *args
    @@instance
  end

  def initialize w: 1280, h: 720, size: 100, margin: 10
    @arrows = {
      left: {
        w: size,
        h: size,
        x: margin,
        y: h/2 - size/2,
        path: SPRITE,
        flip_horizontally: true,
      },
      right: {
        w: size,
        h: size,
        x: w - size - margin,
        y: h/2 - size/2,
        path: SPRITE,
      },
    }
  end

  DEFAULT_KEYHELD = Struct.new(:left, :right).new(nil, nil)

  def render key_held: DEFAULT_KEYHELD
    @arrows[:left][:a] = key_held.left ? 30 : 10
    @arrows[:right][:a] = key_held.right ? 30 : 10

    [
      @arrows[:left].sprite,
      @arrows[:right].sprite
    ]
  end
end
