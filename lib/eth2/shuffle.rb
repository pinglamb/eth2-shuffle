# frozen_string_literal: true

require_relative 'shuffle/version'

require 'digest'

module Eth2
  # Shuffling base on swap-or-not
  # Intro here: https://hackmd.io/@benjaminion/shuffling
  # Advantages:
  # - Shuffling a single element
  # Disadvantages:
  # - Less efficient than Fisher-Yates shuffle
  # Referencing: https://github.com/protolambda/eth2-shuffle
  module Shuffle
    class << self
      def shuffle_list(input, rounds, seed)
        list_size = input.size

        return input if list_size == 0

        output = input.dup

        rounds.times do |r|
          buffer = "#{[seed].pack('H*')}#{[r].pack('C')}"
          pivot = [digest(buffer)[0..15]].pack('H*').unpack1('Q<*') % list_size

          m1 = (pivot + 1) / 2
          (0...m1).each do |i|
            j = pivot - i
            buffer = "#{[seed].pack('H*')}#{[r].pack('C')}#{[j / 256].pack('V')}"
            source = digest(buffer)
            byte = source[((j % 256) / 8 * 2)..((j % 256) / 8 * 2 + 1)].hex
            bit = (byte / 2**(j % 8)) & 0x1

            output[i], output[j] = output[j], output[i] if bit == 1
          end

          m2 = (pivot + list_size + 1) / 2

          ((pivot + 1)...m2).each do |i|
            j = list_size - (i - pivot)
            buffer = "#{[seed].pack('H*')}#{[r].pack('C')}#{[j / 256].pack('V')}"
            source = digest(buffer)
            byte = source[((j % 256) / 8 * 2)..((j % 256) / 8 * 2 + 1)].hex
            bit = (byte / 2**(j % 8)) & 0x1

            output[i], output[j] = output[j], output[i] if bit == 1
          end
        end

        output
      end

      private

      def digest(hex)
        Digest::SHA256.hexdigest(hex)
      end

      def pp(hex)
        "[#{hex[0..1].hex} #{hex[2..3].hex} #{hex[4..5].hex} #{hex[6..7].hex} #{hex[8..9].hex} #{hex[10..11].hex} ...]"
      end
    end
  end
end
