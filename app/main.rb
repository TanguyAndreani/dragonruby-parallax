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
    t = args.state.tick_count % (1280 / i)
    args.outputs.sprites << [t * -1 * i, 0, 1280, 720, f]
    args.outputs.sprites << [1278 + t * -1 * i, 0, 1280, 720, f]
  end
end