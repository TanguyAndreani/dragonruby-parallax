$gtk.reset

class Vector2d
  def self.abs_diff vec1, vec2
    {
      x: (vec1[:x] - vec2[:x]).abs,
      y: (vec1[:y] - vec2[:y]).abs
    }
  end

  def self.diff vec1, vec2
    {
      x: vec1[:x] - vec2[:x],
      y: vec1[:y] - vec2[:y]
    }
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
end
