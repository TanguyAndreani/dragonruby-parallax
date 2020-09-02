class Utils
  def self.set_args args
    @args = args
  end

  def self.distance a, b
    if a[:x] && b[:x] && a[:y] && b[:y]
      Math.sqrt((b[:x]-a[:x]).abs**2 + (b[:y]-a[:y]).abs**2)
    elsif a[:x].nil? || b[:x].nil?
      (b[:y]-a[:y]).abs
    else
      (b[:x]-a[:x]).abs
    end
  end

  def self.corners rect
    {
      bottom_left: {x: rect[:x], y: rect[:y]},
      bottom_right: {x: rect[:x]+rect[:w], y: rect[:y]},
      top_left: {x: rect[:x], y: rect[:y]+rect[:h]},
      top_right: {x: rect[:x]+rect[:w], y: rect[:y]+rect[:h]},
      #center: {x: (rect[:x]*2+rect[:w])/2, y: (rect[:y]*2+rect[:h])/2}
    }
  end

  def self.get_stub name
    @stubs ||= Hash.new(0)
    @stubs[name]
  end

  def self.set_stub name, value
    @stubs ||= Hash.new(0)
    @stubs[name] = value
  end

  set_stub :empty_hash, Hash.new(0)

  def self.mouse_state
    if @args.inputs.mouse.down
      @mouse_state = :down
    elsif @args.inputs.mouse.up
      @mouse_state = :up
    end
    @mouse_state
  end
end
