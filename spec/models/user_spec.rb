# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user, email: email, password: password) }

  let(:email) { 'test@email.com' }
  let(:password) { 'password' }

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

  context 'when pasword is empty' do
    let(:password) { '' }

    it { expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context 'when pasword is small' do
    let(:password) { 'small' }

    it { expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
