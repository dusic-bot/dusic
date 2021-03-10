# frozen_string_literal: true

class VkdonateDonationsCheckerService
  REQUEST_COUNT = 50
  PAGES_FETCH_INTERVAL = 5.seconds

  class << self
    def call
      last_external_id = VkdonateDonation.order(external_id: :desc).first&.external_id
      donations_data = fetch_donations_until(last_external_id)
      donations_data.each { |data| VkdonateDonationCreatorService.call(data) }
    end

    private

    def fetch_donations_until(last_external_id)
      donations = []
      last_index = nil
      loop do
        page = request(donations.size)
        donations.concat(page)
        last_index = donations.find_index { |d| d.id <= last_external_id.to_i }
        break if last_index.present? || page.empty? || page.size != REQUEST_COUNT

        sleep PAGES_FETCH_INTERVAL
      end
      last_index.present? ? donations[0...last_index] : donations
    end

    def request(offset)
      ::VKDONATE_CLIENT.donates(count: REQUEST_COUNT, offset: offset)
    rescue StandardError => e
      Rails.logger.error "Vkdonate request error: #{e}\n#{e.backtrace}"
      []
    end
  end
end
