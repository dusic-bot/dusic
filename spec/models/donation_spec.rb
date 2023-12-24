# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Donation do
  subject(:instance) { build(:donation, size:) }

  let(:size) { 10 }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end

  context 'when size is zero' do
    let(:size) { 0 }

    it { expect { instance.save! }.not_to raise_error }
  end

  context 'when size is negative' do
    let(:size) { -1 }

    it { expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
