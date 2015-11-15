require 'wavefile'
require './synth'

class Player

  OUTPUT_FILENAME = "mysound.wav"

  def initialize
    @samples = []
  end

  def add_samples(samples)
    @samples += samples
  end

  def play
    buffer = WaveFile::Buffer.new(@samples, WaveFile::Format.new(:mono, :float, Synth::SAMPLE_RATE))
    WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_16, Synth::SAMPLE_RATE)) do |writer|
      writer.write(buffer)
    end
    `afplay #{OUTPUT_FILENAME}`
  end

end
