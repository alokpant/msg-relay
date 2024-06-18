# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # GET /users

  # @param params [Hash] api params
  # @argument api_limit [Number] indicates how many users to return (Default 10)
  # @return [User] array of available users
  # @example_request
  #   { limit: 10 }
  # @example_response
  #   [
  #     {
  #       "id": 146,
  #       "email": "apitesting@gmail.com",
  #       "json_web_token": "da608ffc3870f0ed63825d5959542af3",
  #       "created_at": "2024-06-12T17:31:34.804Z",
  #       "updated_at": "2024-06-12T17:31:34.804Z"
  #     },
  #     {
  #       "id": 147,
  #       "email": "apitesting2@gmail.com",
  #       "json_web_token": "ea80823c38lled63825d5959542af3",
  #       "created_at": "2024-06-12T17:31:34.804Z",
  #       "updated_at": "2024-06-12T17:31:34.804Z"
  #     },
  #   ]
  def index
    users = User.limit(api_response_limit)

    render json: users
  end

  # POST /users

  # @param params [Hash] api params
  # @argument user [Hash] email of user to be created
  # @return [User] array of available users
  # @example_request
  #   { email: 'apitesting@gmail.com' }
  # @example_response
  #   {
  #     "id": 146,
  #     "email": "apitesting@gmail.com",
  #     "json_web_token": "da608ffc3870f0ed63825d5959542af3",
  #     "created_at": "2024-06-12T17:31:34.804Z",
  #     "updated_at": "2024-06-12T17:31:34.804Z"
  #   }
  def create
    user = User.find_by(email: params[:email])

    if user
      render_json_response(
        { error: 'Email already exists' },
        :unprocessable_entity
      )
    else
      user = User.new(user_params)

      return render_json_response(user, :created) if user.save

      render_json_response(user.errors, :unprocessable_entity)
    end
  end

  private

  def render_json_response(data, status)
    render json: data, status: status
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
