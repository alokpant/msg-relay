# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  # GET /messages

  # @param params [Hash] api params
  # @argument api_limit [Number] indicates how many users to return (Default 10)
  # @argument user_id [Number] ID of user for whom to return all messages (Optional)
  # @return [Hash] attributes of messages
  # @example_request
	#   { limit: 10, user_id: 146 }
  # @example_response
  #   [
  #     {
  #       "id": 1,
  #       "user_id": 146,
  #       "title": "hello",
  #       "body": "world",
  #       "created_at": "2024-06-03T07:58:14.041Z",
  #       "updated_at": "2024-06-03T07:58:14.041Z"
  #     },
  #     {
  #       "id": 2,
  #       "user_id": 146,
  #       "title": "message 0",
  #       "body": "body 0",
  #       "created_at": "2024-06-03T09:17:10.224Z",
  #       "updated_at": "2024-06-03T09:17:10.224Z"
  #     },
  #   ]
  def index
    messages = Message.limit(api_response_limit)
    messages = messages.where(user_id: params[:user_id]) if params[:user_id]

    render json: messages
  end

  # GET /messages/:id

  # @param params [Hash] api params
  # @return [Hash] a single message
  # @example_request
	#   { id: 1 }
  # @example_response
  #   {
  #     "id": 1,
  #     "user_id": 146,
  #     "title": "hello",
  #     "body": "world",
  #     "created_at": "2024-06-03T07:58:14.041Z",
  #     "updated_at": "2024-06-03T07:58:14.041Z"
  #   }
  def show
    message = Message.find(params[:id])
    render json: message
  end

  # POST /messages

  # @param params [Hash] api params
  # @argument message [Hash] includes title and body to create message
  # @return [Hash] a single message
  # @example_request
	#   {
  #     message: {
  #       title: 'Title for message',
  #       body: 'Body for message'
  #     }
  #   }
  # @example_response
  #   {
  #     "id": 1,
  #     "user_id": 146, (Based on json_web_token pass in Header Authorization)
  #     "title": "Title for message",
  #     "body": "Body for message",
  #     "created_at": "2024-06-03T07:58:14.041Z",
  #     "updated_at": "2024-06-03T07:58:14.041Z"
  #   }
  def create
    message = current_user.messages.build(message_params)
    if message.save
      render json: message, status: :created
    else
      return_error_json
    end
  end

  # PUT /messages/:id

  # @param params [Hash] api params
  # @argument message [Hash] includes title and body to create message
  # @return [Hash] a single message
  # @example_request
	#   {
  #     id: 146,
  #     message: {
  #       title: 'New title for message',
  #       body: 'New body for message'
  #     }
  #   }
  # @example_response
  #   {
  #     "id": 1,
  #     "user_id": 146, (Based on json_web_token pass in Header Authorization)
  #     "title": "New title for message",
  #     "body": "New body for message",
  #     "created_at": "2024-06-03T07:58:14.041Z",
  #     "updated_at": "2024-06-03T07:58:14.041Z"
  #   }
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
    return if current_user.present?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def current_user
    return @current_user if @current_user

    token = request&.headers&.[]('Authorization')
    @current_user = User.find_by(json_web_token: token)
  end
end
