class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request, only: [:login, :signup]
  before_action :check_avatar, only: [:signup]

  def index
    @users = User.all

    render json: { status: true, data: @users }
  end

  def signup
    begin
      avatar = params[:user][:avatar]

      user = User.new(**user_params, avatar: avatar.to_sym)
      user.save!

      render json: { data: @user }, status: :ok
    rescue StandardError => e
      render json: { message: @user.errors.full_messages.join(', ').capitalize, error: e.message }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(username: params[:username])
    render json: { error: 'Wrong credentials' }, status: :not_found and return if @user.nil?

    token = jwt_encode(user_id: @user.id)

    if token.nil?
      render json: { error: 'Token no generated' }, status: :unauthorized
    else
      render json: { token: token }, status: :ok
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :password)
    end

    def check_avatar
      render json: { message: 'El avatar esta vacío' }, status: :unprocessable_entity and return if params[:user][:avatar].nil?
    end
end