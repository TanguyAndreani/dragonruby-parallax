class Utils
  # SETUP METHODS BEGIN

  def self.set_args args
    @args = args
  end

  # SETUP METHODS END

  # RECT2D HELPERS BEGIN
  # `rect` can be anything that reponds to #[] and has readable :h, :w, :x, :y properties

  def self.corners rect
    {
      bottom_left: {x: rect[:x], y: rect[:y]},
      bottom_right: {x: rect[:x]+rect[:w], y: rect[:y]},
      top_left: {x: rect[:x], y: rect[:y]+rect[:h]},
      top_right: {x: rect[:x]+rect[:w], y: rect[:y]+rect[:h]},
      #center: {x: (rect[:x]*2+rect[:w])/2, y: (rect[:y]*2+rect[:h])/2}
    }
  end

  # RECT2D HELPERS END

  # STUBS BEGIN
  # Just a helper to give names to small values which you may reuse.
  # The rule is to never mutate them. You just use them as values.

  def self.get_stub name
    @stubs ||= Hash.new(0)
    @stubs[name]
  end

  def self.set_stub name, value
    @stubs ||= Hash.new(0)
    @stubs[name] = value
  end

  def self.set_stub_safe name, value
    @stubs ||= Hash.new(0)
    @stubs[name] ||= value
  end

  set_stub :empty_hash, Hash.new(0)

  # STUBS END

  # MOUSE HELPERS BEGIN

  def self.mouse_state
    if @args.inputs.mouse.down
      @mouse_state = :down
    elsif @args.inputs.mouse.up
      @mouse_state = :up
    end
    @mouse_state
  end

  # MOUSE HELPERS END
end
