# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordServer, type: :model do
  subject(:instance) { build(:discord_server, external_id: external_id) }

  let(:external_id) { 482473013246296084 }

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
    before { create(:discord_server, external_id: external_id) }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
