require './synth'
require './player'

player = Player.new
synth = Synth.new(base_frequency: 640.0, note_per_second: 10)

minor = [0, 3, 7, 8, 12, 15, 19, 20, 24]
minor3 = minor.map{|i|i+3}

0.upto(3).map do
  player.add_samples [minor, minor3].map{ |arr|
    values = arr.shuffle.first(8)
    synth.get_freqencies(values, tone: :triangle) + synth.get_freqencies(values, tone: :sine)
  }.flatten
end

player.play
