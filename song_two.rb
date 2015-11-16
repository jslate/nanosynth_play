require './synth'
require './player'

player = Player.new
synth = Synth.new

first = [0, 4, 7, 12]
fourth = first.map{|i|i+5}
fifth = first.map{|i|i+7} + [4]

0.upto(3).map do
  player.add_samples [first, fourth, first, fifth].map{ |arr|
    values = arr.shuffle
    synth.get_freqencies(values, tone: :sine)
  }.flatten
end

player.add_samples synth.get_freqencies([0] * 5, tone: :sine).flatten

player.play
