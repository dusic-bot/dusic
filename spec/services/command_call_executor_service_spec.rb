# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandCallExecutorService do
  subject(:result) { described_class.call(shard_identifier, payload) }

  xit { expect(result).to be_nil }
end
