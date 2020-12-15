# frozen_string_literal: true

require_relative 'shuffle/version'

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
      def shuffle_list(input, rounds)
        list_size = input.size

        output = input.dup

        rounds.times do
          pivot = rand(list_size)
          m1 = pivot / 2
          m2 = m1 + list_size / 2

          # puts "Pivot: #{pivot}"
          # puts "m1: #{m1}"
          # puts "m2: #{m2}"

          (m1..pivot).each do |i|
            ii = pivot - i
            output[i], output[ii] = output[ii], output[i] if rand(2)
          end

          (pivot..m2).each do |j|
            jj = list_size - 1 - (j - pivot)
            output[j], output[jj] = output[jj], output[j] if rand(2)
          end
        end

        output
      end
    end
  end
end
