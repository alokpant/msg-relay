# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    messages = Message.limit(api_response_limit)
    messages = messages.where(user_id: params[:user_id]) if params[:user_id]

    render json: messages
  end

  def show
    message = Message.find(params[:id])
    render json: message
  end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      render json: message, status: :created
    else
      return_error_json
    end
  end

  def update
    message = current_user.messages.find(params[:id])

    if message.update(message_params)
      render json: message, status: :ok
    else
      return_error_json
    end
  end

  private

  def message_params
    params.require(:message).permit(:title, :body)
  end

  def render_error_json
    render json: @message.errors, status: :unprocessable_entity
  end

  def authenticate_user!
    return unless current_user.nil?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def current_user
    return @current_user if @current_user

    token = request&.headers&.[]('Authorization')
    @current_user = User.find_by(json_web_token: token)
  end
end
