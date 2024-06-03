# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id             :bigint           not null, primary key
#  email          :string           not null
#  json_web_token :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class User < ApplicationRecord
  has_many :messages, dependent: :destroy

  # rubocop:todo Rails/UniqueValidationWithoutIndex
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_json_web_token
  before_update :validate_json_web_token_presence

  private

  def generate_json_web_token
    self.json_web_token = SecureRandom.hex
  end

  def validate_json_web_token_presence
    return if json_web_token.present?

    errors.add(:json_web_token, "can't be blank")
    throw(:abort)
  end
end
