# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  validates :avatar, presence: true, blob: { content_type: ['image/png', 'image/jpeg', 'image/gif'], size_range: 1..(5.megabytes) }
end
