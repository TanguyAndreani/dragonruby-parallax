$gtk.reset

require 'lib/window.rb'

class FPS
  # we do everything at once to make this easily copy pastable
  def self.render_standalone win
    @dummy ||= Window.add name: win, w: 145, h: 55, margin_left: 10, margin_top: 10, position: :top_left
    Window.render_into win, [
      [0, Window.with(win).h, "FPS: #{$gtk.current_framerate.to_s.to_i}", 7].label,
      [0, 0, 145, 55, 0, 0, 0, 100].solid
    ]
    Window.render win
  end
end
