# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:instance) { build(:user, email:, password:) }

  let(:email) { 'test@email.com' }
  let(:password) { 'password' }

  it 'allows user creation' do
    expect { instance.save! }.not_to raise_error
  end

  context 'when email is empty' do
    let(:email) { '' }

    it { expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context 'when email is not an email' do
    let(:email) { 'asfasfasfasf' }

    it { expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context 'when pasword is empty' do
    let(:password) { '' }

    it { expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end

  context 'when pasword is small' do
    let(:password) { 'small' }

    it { expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
