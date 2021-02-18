# frozen_string_literal: true

class VkdonateDonation < ApplicationRecord
  belongs_to :donation

  validates :vk_user_external_id, presence: true
  validates :external_id, presence: true
end
