class Window
  def self.set_args args
    @args = args
  end

  def self.add_window name: :root, w: 1280, h: 720, x: 0, y: 0
    @windows ||= Hash.new
    @windows[name] = Window.new(
      name: name,
      w: w,
      h: h,
      x: x,
      y: y
    )
    @windows[name]
  end

  def self.render name
    @windows[name].render @args
  end

  def self.render_into name, sprites
    @windows[name].render_into @args, sprites
  end

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
    args.render_target(@name).sprites << sprites
  end

  def render args
    args.outputs.sprites << [@x, @y, @w, @h, @name]
  end
end
