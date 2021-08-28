# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#title_tag' do
    subject(:result) { helper.title_tag(title, env_prefix: env_prefix) }

    let(:title) { 'title' }
    let(:env_prefix) { false }

    it { expect(result).to eq('<title>title</title>') }

    context 'when env_prefix option enabled' do
      let(:env_prefix) { true }

      let(:title) { 'prefixed' }

      context 'when test environment' do
        it { expect(result).to eq('<title>prefixed</title>') }
      end

      context 'when development environment' do
        before { allow(Rails).to receive(:env).and_return('development').once }

        it { expect(result).to eq('<title>DEV | prefixed</title>') }
      end

      context 'when production environment' do
        before { allow(Rails).to receive(:env).and_return('production').once }

        it { expect(result).to eq('<title>prefixed</title>') }
      end
    end
  end
end
