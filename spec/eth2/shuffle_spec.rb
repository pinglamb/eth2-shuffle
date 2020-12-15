# frozen_string_literal: true

RSpec.describe Eth2::Shuffle do
  describe '.shuffle_list' do
    it 'works' do
      input = (1..10).to_a
      expect(Eth2::Shuffle.shuffle_list(input, 90)).to eq(input)
    end
  end
end
