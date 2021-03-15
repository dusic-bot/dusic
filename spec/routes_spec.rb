# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  describe '/' do
    it { expect(get: '/').to route_to(controller: 'pages', action: 'root') }
  end

  describe '/admin/' do
    it { expect(get: '/admin/').to route_to(controller: 'admin/pages', action: 'root') }

    it { expect(get: '/admin/donation_id').to route_to(controller: 'admin/pages', action: 'donation_id') }

    it 'routes jwt_token', :aggregate_failures do
      expect(get: '/admin/jwt_token').to route_to(controller: 'admin/pages', action: 'jwt_token')
      expect(post: '/admin/jwt_token').to route_to(controller: 'admin/pages', action: 'jwt_token')
    end

    it 'routes websocket_server', :aggregate_failures do
      expect(get: '/admin/websocket_server').to route_to(controller: 'admin/pages', action: 'websocket_server')
      expect(post: '/admin/websocket_server').to route_to(controller: 'admin/pages', action: 'websocket_server')
    end

    it 'routes donation_adder', :aggregate_failures do
      expect(get: '/admin/donation_adder').to route_to(controller: 'admin/pages', action: 'donation_adder')
      expect(post: '/admin/donation_adder').to route_to(controller: 'admin/pages', action: 'donation_adder')
    end

    it 'routes audios', :aggregate_failures do
      expect(get: '/admin/audios').to route_to(controller: 'admin/audios', action: 'index')
      expect(get: '/admin/audios/manager/id').to route_to(
        controller: 'admin/audios', action: 'show', manager: 'manager', id: 'id'
      )
    end
  end
end
