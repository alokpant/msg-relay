# frozen_string_literal: true

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    users = User.limit(api_size)

    render json: users
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      render_json_response(
        { error: 'Email already exists'},
        :unprocessable_entity
      )
    else
      user = User.new(user_params)

      return render_json_response(user, :created) if user.save
        
      render_json_response(user.errors, :unprocessable_entity)
    end
  end

  private

  def api_size
    params[:limit] || 10
  end

  def render_json_response(data, status)
    render json: data, status:
  end

  def user_params
    params.require(:user).permit(:email)
  end
end