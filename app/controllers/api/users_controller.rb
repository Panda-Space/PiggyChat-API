class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request, only: [:login, :signup]
  before_action :check_user_avatar, only: [:signup]
  before_action :check_email_and_password, only: [:login]

  def index
    @users = User.all

    render json: { status: true, data: @users }
  end

  def signup
    begin
      avatar = params[:user][:avatar]

      user = User.new(**user_params, avatar: avatar.to_sym)
      user.save!

      render json: { data: user }, status: :ok
    rescue StandardError => e
      render json: { message: user.errors.full_messages.join(', ').capitalize, error: e.message }, status: :unprocessable_entity
    end
  end

  def login
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)
    render json: { error: 'No existe ningun usuario con este e-mail' }, status: :not_found and return if user.nil?

    if user.authenticate(password)
      token = jwt_encode(user_id: user.id)
      render json: { message: 'Usuario autenticado exitosamente', data: { token: token } }, status: :ok
    else
      render json: { message: 'Credenciales incorrectas, intentalo nuevamente' }, status: :unauthorized
    end

    raise StandardError, 'No existe ningun usuario con este e-mail' if user.nil?
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :password)
    end

    def check_user_avatar
      render json: { message: 'El avatar esta vacío' }, status: :unprocessable_entity and return if params[:user][:avatar].nil?
    end

    def check_email_and_password
      render json: { message: 'El email esta vacío' }, status: :unprocessable_entity and return if params[:email].nil?
      render json: { message: 'La contraseña esta vacío' }, status: :unprocessable_entity and return if params[:password].nil?
    end
end