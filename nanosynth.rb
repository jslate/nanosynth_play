require 'wavefile'

OUTPUT_FILENAME = "mysound.wav"
SAMPLE_RATE = 44100
TWO_PI = 2 * Math::PI
RANDOM_GENERATOR = Random.new
NOTES_PER_OCTAVE = 12
MAX_AMPLITUDE = 0.5
BASE_FREQUENCY = 440.0

def main

  minor = [0, 3, 7, 8, 12, 15, 19, 20, 24]
  minor3 = minor.map{|i|i+3}

  samples = []

  32.times do |j|
    ([0] + (j.odd? ? minor : minor3).shuffle.slice(1,7)).map {|i|BASE_FREQUENCY * 2**Rational(i,NOTES_PER_OCTAVE)}.tap {|a|
      r = 1
      samples += a.map{|a|[a,r]}
      r = 8
      samples += a.map{|a|[a,r]}}
  end



  # Generate 1 second of sample data at the given frequency and amplitude.
  # Since we are using a sample rate of 44,100Hz,
  # 44,100 samples are required for one second of sound.
  samples = samples.map{|f|generate_sample_data(:sine, SAMPLE_RATE, f[0].to_f, f[1]) }.flatten

  # Wrap the array of samples in a Buffer, so that it can be written to a Wave file
  # by the WaveFile gem. Since we generated samples between -1.0 and 1.0, the sample
  # type should be :float
  buffer = WaveFile::Buffer.new(samples, WaveFile::Format.new(:mono, :float, SAMPLE_RATE))

  # Write the Buffer containing our samples to a 16-bit, monophonic Wave file
  # with a sample rate of 44,100Hz, using the WaveFile gem.
  WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_16, SAMPLE_RATE)) do |writer|
    writer.write(buffer)
  end
  `afplay #{OUTPUT_FILENAME}`
end

# The dark heart of NanoSynth, the part that actually generates the audio data
def generate_sample_data(wave_type, num_samples, frequency, mod)
  position_in_period = 0.0
  position_in_period_delta = frequency / SAMPLE_RATE

  # Initialize an array of samples set to 0.0. Each sample will be replaced with
  # an actual value below.
  samples = [].fill(0.0, 0, num_samples/8)

  (num_samples/8).times do |i|
    # Add next sample to sample list. The sample value is determined by
    # plugging the period offset into the appropriate wave function.

    if wave_type == :sine
      if i % mod != 0
        samples[i] = Math::sin(position_in_period * TWO_PI) * MAX_AMPLITUDE
      else
        # samples[i] = (position_in_period >= 0.5) ? max_amplitude : -max_amplitude
        # samples[i] = ((position_in_period * 2.0) - 1.0) * max_amplitude
        samples[i] = MAX_AMPLITUDE - (((position_in_period * 2.0) - 1.0) * MAX_AMPLITUDE * 2.0).abs
      # samples[i] = RANDOM_GENERATOR.rand(-max_amplitude..max_amplitude)
      end
    end

    position_in_period += position_in_period_delta

    # Constrain the period between 0.0 and 1.0
    if(position_in_period >= 1.0)
      position_in_period -= 1.0
    end
  end

  samples
end

def sine

end

main
