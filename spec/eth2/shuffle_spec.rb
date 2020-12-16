# frozen_string_literal: true

require 'csv'

RSpec.describe Eth2::Shuffle do
  tests = CSV.parse(file_fixture('tests.csv').read)
  tests.each.with_index do |data, r|
    seed = data[0]
    size = data[1].to_i
    input = (data[2] || '').split(':').collect(&:to_i)
    output = (data[3] || '').split(':').collect(&:to_i)

    it "permute_index - #{r}" do
      size.times do |i|
        permuted = Eth2::Shuffle.permute_index(90, i, size, seed)
        expect(output[permuted]).to eq(input[i])
      end
    end

    it "unpermute_index - #{r}" do
      size.times do |i|
        permuted = Eth2::Shuffle.unpermute_index(90, i, size, seed)
        expect(input[permuted]).to eq(output[i])
      end
    end

    it "shuffle_list - #{r}" do
      expect(Eth2::Shuffle.shuffle_list(input, 90, seed)).to eq(output)
    end

    it "unshuffle_list - #{r}" do
      expect(Eth2::Shuffle.unshuffle_list(output, 90, seed)).to eq(input)
    end
  end
end
