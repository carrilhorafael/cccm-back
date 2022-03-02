class AuthController < ApplicationController
  def login
    action = User::Login.call(email: params[:user][:email], password: params[:user][:password])

    if action.success?
      render json: { token: action.token, user: UserSerializer.new(action.user) }
    else
      render json: { message: action.error }, status: :unprocessable_entity
    end
  end

  def reset
    key = params[:key]

    action = User::Reset.call(
      key: params[:key],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
    )

    if action.fail?
      render json:{ message: action.error }, status: :unprocessable_entity
    end

  end
end
