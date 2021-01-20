# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vk::AudioManager do
  subject(:instance) { described_class.new('login', 'password') }

  let(:vk_client) { instance_double(VkMusic::Client) }

  before do
    allow(VkMusic::Client).to receive(:new).with(login: 'login', password: 'password').and_return(vk_client)
  end

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end
end
