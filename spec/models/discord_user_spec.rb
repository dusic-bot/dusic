# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordUser, type: :model do
  subject(:instance) { described_class.new(external_id: external_id) }

  let(:external_id) { 208117693537058817 }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end

  context 'when nil id' do
    let(:external_id) { nil }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  context 'when already exists' do
    before { described_class.create(external_id: external_id) }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
