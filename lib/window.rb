class Window
  def self.set_args args
    @args = args
  end

  def self.render name
    @windows[name].render @args
  end

  def self.render_into name, sprites
    @windows[name].render_into @args, sprites
  end

  def self.top_left name
    [0, @windows[name].h]
  end

  def self.get_size name
    [@windows[name].w, @windows[name].h]
  end

  def self.add **args
    @windows ||= Hash.new
    @windows[args[:name]] = self.new args
  end

  attr_reader :name, :w, :h, :x, :y

  def initialize name: :root, w: 1280, h: 720, x: 0, y: 0
    @name = name
    @w, @h = w, h
    @x, @y = x, y
    self
  end

  def set_size w, h
    @w, @h = w, h
  end

  def set_pos x, y
    @x, @y = x, y
  end

  def render_into args, sprites
    args.render_target(@name).primitives << sprites
  end

  def render args
    args.outputs.sprites << [@x, @y, @w, @h, @name]
  end
end
