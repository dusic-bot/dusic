# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  describe '/' do
    it { expect(get: '/').to route_to(controller: 'pages', action: 'root') }
  end
end
