# frozen_string_literal: true

class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/.freeze

  validates :email, format: EMAIL_REGEX
end
