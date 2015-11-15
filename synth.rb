class Synth

  SAMPLE_RATE = 44100
  TWO_PI = 2 * Math::PI
  NOTES_PER_OCTAVE = 12
  MAX_AMPLITUDE = 0.5
  BASE_FREQUENCY = 440.0

  def get_freqencies(arr)
    [1,8].map do |mod|
      arr.map do |i|
        generate_sample_data(:sine, SAMPLE_RATE, get_frequency(i), mod)
      end
    end
  end

  def get_frequency(note)
    BASE_FREQUENCY * 2**Rational(note,NOTES_PER_OCTAVE)
  end

  def sine(position_in_period)
    Math::sin(position_in_period * TWO_PI) * MAX_AMPLITUDE
  end

  def triangle(position_in_period)
    MAX_AMPLITUDE - (((position_in_period * 2.0) - 1.0) * MAX_AMPLITUDE * 2.0).abs
  end

  def generate_sample_data(wave_type, num_samples, frequency, mod)
    position_in_period = 0.0
    position_in_period_delta = frequency / SAMPLE_RATE

    samples = [].fill(0.0, 0, num_samples/8)

    (num_samples/8).times do |i|

      samples[i] = i % mod != 0 ? sine(position_in_period) : samples[i] = triangle(position_in_period)
      position_in_period += position_in_period_delta

      if(position_in_period >= 1.0)
        position_in_period -= 1.0
      end
    end

    samples
  end

end
