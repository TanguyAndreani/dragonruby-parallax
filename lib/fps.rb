require 'lib/window.rb'

class FPS
  # we do everything at once to make this easily copy pastable
  def self.render_standalone win
    @window ||= Window.add name: win, y: -720+50, w: 1280, h: 720
    x, y = Window.top_left win
    w, h = Window.get_size win
    Window.render_into win, [
      [x+10, y-10, "FPS: #{$gtk.current_framerate.to_s.to_i}", 7].label,
      [0, 0, w, h, 0, 0, 0, 100].solid
    ]
    Window.render win
  end
end
