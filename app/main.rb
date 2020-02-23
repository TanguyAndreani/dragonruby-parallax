WIDTH, HEIGHT = 1280, 720

def layers
  [
    'layer1.png',
    'layer2.png',
    'layer3.png',
    'layer4.png',
    'layer5.png',
  ].map { |s| "assets/#{s}" }
end

def tick args
  layers.each_with_index do |f, i|
    i += 1
    t = args.state.tick_count % (WIDTH / i)
    x_coord = t * i * -1
    args.outputs.sprites << [x_coord, 0, WIDTH, HEIGHT, f]
    args.outputs.sprites << [x_coord + (WIDTH - 2), 0, WIDTH, HEIGHT, f]
  end
end