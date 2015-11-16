require './synth'
require './player'

player = Player.new
synth = Synth.new(note_per_second: 10, base_frequency: 120.0)

tone = :saw

[0,3,6,9].tap do |arr|
  0.upto(12).each do |i|
    notes = arr.map{|v|v+i}
    notes.reverse! if i % 3 == 0
    player.add_samples synth.get_freqencies(notes, tone: tone).flatten
    player.add_samples synth.get_freqencies(notes.reverse.slice(1, 3), tone: tone).flatten
  end
  12.downto(0).each do |i|
    notes = arr.map{|v|v+i}
    notes.reverse! if i % 4 == 0
    player.add_samples synth.get_freqencies(notes.reverse, tone: tone).flatten
    player.add_samples synth.get_freqencies(notes.slice(1, 3), tone: tone).flatten
  end
end

player.play
