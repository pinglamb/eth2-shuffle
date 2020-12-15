# frozen_string_literal: true

require 'csv'

RSpec.describe Eth2::Shuffle do
  describe '.shuffle_list' do
    it 'works' do
      tests = CSV.parse(file_fixture('tests.csv').read)
      tests.each do |data|
        seed = data[0]
        size = data[1]
        input = (data[2] || '').split(':').collect(&:to_i)
        expected_output = (data[3] || '').split(':').collect(&:to_i)

        expect(Eth2::Shuffle.shuffle_list(input, 90, seed)).to eq(expected_output)
      end
    end
  end
end
