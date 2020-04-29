LAYERS = [
    'layer1.png',
    'layer2.png',
    'layer3.png',
    'layer4.png',
    'layer5.png',
].map { |s| "assets/#{s}" }

def tick args
  w = args.grid.right
  h = args.grid.top

  LAYERS.each_with_index do |f, i|
    i += 1
    t = args.state.tick_count % (w / i)
    x_coord = t * i * -1
    args.outputs.sprites << [x_coord, 0, w, h, f]
    args.outputs.sprites << [x_coord + (w - 2), 0, w, h, f]
  end
end