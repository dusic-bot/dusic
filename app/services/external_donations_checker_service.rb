# frozen_string_literal: true

class ExternalDonationsCheckerService
  class << self
    def call
      last_external_id = donation_class.order(external_id: :desc).first&.external_id
      donations_data = fetch_donations_until(last_external_id)
      donations_data.each { |data| donation_creator_service.call(data) }
    end

    private

    # Abstract methods
    # :nocov:
    def request_count
      raise NotImplementedError
    end

    def pages_fetch_interval
      raise NotImplementedError
    end

    def donation_class
      raise NotImplementedError
    end

    def donation_creator_service
      raise NotImplementedError
    end

    def unsafe_fetch(offset)
      raise NotImplementedError
    end

    def donation_external_id(donation)
      raise NotImplementedError
    end
    # :nocov:

    def fetch_donations_until(last_external_id)
      donations = []
      last_index = nil
      loop do
        page = request(donations.size)
        donations.concat(page)
        last_index = donations.find_index { |d| donation_external_id(d) <= last_external_id.to_i }
        break if stop_fetching?(last_index, page)

        sleep pages_fetch_interval
      end
      last_index.present? ? donations[0...last_index] : donations
    end

    def stop_fetching?(last_index, page)
      last_index.present? || page.empty? || page.size != request_count
    end

    def request(offset)
      unsafe_fetch(offset)
    rescue StandardError => e
      Rails.logger.error "#{donation_class} request error: #{e}\n#{e.backtrace}"
      []
    end
  end
end
