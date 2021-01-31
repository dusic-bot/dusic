# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  describe '/' do
    it { expect(get: '/').to route_to(controller: 'pages', action: 'root') }
  end

  describe '/admin/' do
    it { expect(get: '/admin/').to route_to(controller: 'admin/pages', action: 'root') }

    it { expect(get: '/admin/donation_id').to route_to(controller: 'admin/pages', action: 'donation_id') }

    it { expect(get: '/admin/audios').to route_to(controller: 'admin/pages', action: 'audios') }
  end
end
