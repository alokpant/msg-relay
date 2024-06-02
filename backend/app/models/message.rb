# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user

  validates :title, :body, presence: true
end
