# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkdonateDonation do
  subject(:instance) { build(:vkdonate_donation) }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end
end
