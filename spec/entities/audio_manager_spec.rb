# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioManager do
  subject(:instance) { described_class.new }

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end

  describe '#request' do
    it { expect { instance.request(1, 2) }.to raise_error(NotImplementedError) }
  end

  describe '#url' do
    it { expect { instance.url('audio') }.to raise_error(NotImplementedError) }
  end
end
