# frozen_string_literal: true

class User < ApplicationRecord
  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/.freeze

  validates :email, format: EMAIL_REGEX

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end
