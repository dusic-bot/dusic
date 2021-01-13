# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new(email: email) }

  let(:email) { 'test@email.com' }

  it 'allows user creation' do
    expect { user.save! }.not_to raise_error
  end

  context 'when email is empty' do
    let(:email) { '' }

    it { expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context 'when email is not an email' do
    let(:email) { 'asfasfasfasf' }

    it { expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
