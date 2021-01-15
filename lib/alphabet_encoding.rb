# frozen_string_literal: true

# Positive integer to alphabet string encoder and decoder
module AlphabetEncoding
  # Used symbols list
  ALPHABET = ('a'..'z').to_a + ('A'..'Z').to_a

  # Encode integer
  # @param int [Integer]
  # @result [String]
  def self.encode(int)
    int = int.to_i
    base = ALPHABET.size
    arr = []
    loop do
      arr << ALPHABET[int % base]
      int /= base
      break if int.zero?
    end
    arr.join
  end

  # Decode string
  # @param str [String]
  # @result [Integer]
  def self.decode(str)
    str = str.to_s
    base = ALPHABET.size
    int = 0
    str.each_char.with_index(0) do |ch, i|
      int += ALPHABET.find_index(ch) * (base**i)
    end
    int
  end
end
