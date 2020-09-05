$gtk.reset

class Platform
  # Possible values:
  # :emscripten (brower)
  # :linux
  # :mac_os_x
  # :windows

  class << self
    def set
      @platform ||= $gtk.platform.downcase.gsub(' ', '_').to_sym
    end

    def get
      @platform
    end

    def on *platforms
      if platforms.include?(@platform) && block_given?
        yield
      end
    end

    def except *platforms
      if !platforms.include?(@platform) && block_given?
        yield
      end
    end
  end
end
