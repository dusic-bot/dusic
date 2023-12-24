# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkponchikDonation do
  subject(:instance) { build(:vkponchik_donation) }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end
end
