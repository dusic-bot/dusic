# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordUser do
  subject(:instance) { build(:discord_user, external_id:) }

  let(:external_id) { 208117693537058817 }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end

  context 'when nil id' do
    let(:external_id) { nil }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when already exists' do
    before { create(:discord_user, external_id:) }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
