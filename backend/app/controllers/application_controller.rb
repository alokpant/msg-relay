# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def api_response_limit
    params[:limit] || 10
  end
end
