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
end
