require './synth'
require './player'

player = Player.new
synth = Synth.new

minor = [0, 3, 7, 8, 12, 15, 19, 20, 24]
minor3 = minor.map{|i|i+3}

0.upto(15).map do
  player.add_samples [minor, minor3].map{ |arr| synth.get_freqencies(arr.shuffle.first(8)) }.flatten
end

player.play
