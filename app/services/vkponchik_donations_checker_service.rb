# frozen_string_literal: true

class VkponchikDonationsCheckerService
  REQUEST_COUNT = 100
  PAGES_FETCH_INTERVAL = 6.seconds

  class << self
    def call
      last_external_id = VkponchikDonation.order(external_id: :desc).first&.external_id
      donations_data = fetch_donations_until(last_external_id)
      donations_data.each { |data| VkponchikDonationCreatorService.call(data) }
    end

    private

    def fetch_donations_until(last_external_id)
      donations = []
      last_index = nil
      loop do
        page = request(donations.size)
        donations.concat(page)
        last_index = donations.find_index { |d| d['id'].to_i <= last_external_id.to_i }
        break if last_index.present? || page.empty? || page.size != REQUEST_COUNT

        sleep PAGES_FETCH_INTERVAL
      end
      last_index.present? ? donations[0...last_index] : donations
    end

    def request(offset)
      ::VKPONCHIK_CLIENT.request('donates/get', len: REQUEST_COUNT, offset: offset)[:list]
    rescue StandardError => e
      Rails.logger.error "Vkponchik request error: #{e}\n#{e.backtrace}"
      []
    end
  end
end
