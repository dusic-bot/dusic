# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PagesHelper do
  describe '#render_audio_item' do
    subject(:result) { helper.render_audio_item(item, **li_html_params) }

    let(:item) { nil }
    let(:li_html_params) { {} }

    it { expect(result).to be_nil }

    context 'when item is audio' do
      let(:item) { build(:vk_audio, :with_vk_music_external) }

      it { expect(result).to be_a(String) }

      context 'when from some unknown manager' do
        let(:item) { build(:audio) }

        before do
          allow(item).to receive(:artist).and_return('stub')
          allow(item).to receive(:title).and_return('stub')
          allow(item).to receive(:duration).and_return(42)
        end

        it { expect(result).to be_a(String) }
      end
    end

    context 'when item is playlist' do
      let(:item) { build(:vk_playlist, :with_vk_music_external) }

      it { expect(result).to be_a(String) }
    end
  end
end
