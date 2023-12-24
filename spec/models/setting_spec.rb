# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Setting do
  subject(:update_instance) do
    discord_server.setting.update!(language:, volume:, prefix:)
  end

  let(:discord_server) { create(:discord_server) }
  let(:language) { 'ru' }
  let(:volume) { 100 }
  let(:prefix) { nil }

  it 'allows instance update' do
    expect { update_instance }.not_to raise_error
  end

  context 'when settings for server already exist' do
    subject(:create_new_instance) { create(:setting, discord_server:) }

    it 'fails new instance create' do
      expect { create_new_instance }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context 'when unknown language' do
    let(:language) { 'kz' }

    it 'fails instance update' do
      expect { update_instance }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when volume is out of bounds' do
    let(:volume) { 100500 }

    it 'fails instance update' do
      expect { update_instance }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when with custom prefix' do
    let(:prefix) { '!' }

    it 'allows instance update' do
      expect { update_instance }.not_to raise_error
    end

    context 'when empty prefix' do
      let(:prefix) { '' }

      it 'fails instance update' do
        expect { update_instance }.to raise_error(ActiveRecord::RecordInvalid)
      end

      context 'when DM server' do
        let(:discord_server) { create(:discord_server, :dm) }

        it 'allows instance update' do
          expect { update_instance }.not_to raise_error
        end
      end
    end

    context 'when bad prefix' do
      let(:prefix) { 'A A' }

      it 'fails instance creation' do
        expect { update_instance }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
