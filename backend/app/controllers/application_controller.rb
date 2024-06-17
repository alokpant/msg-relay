# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  
  private

  def api_response_limit
    params[:limit] || 10
  end
end
