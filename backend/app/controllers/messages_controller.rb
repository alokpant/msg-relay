# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def index
    messages = Message.limit(api_response_limit)
    messages = messages.where(user_id: params[:user_id]) if params[:user_id]

    render json: messages
  end

  def show
    message = Message.find(params[:id])

    render json: message
  end

  def create; end

  def update; end
end
