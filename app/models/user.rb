class User < ApplicationRecord
  require 'securerandom'
  has_secure_password

  enum avatar: { red: 'red', green: 'green', blue: 'blue' } #TODO: Terminar el path correcto para esto

  validates :username, presence: true, uniqueness: { message: "ya ha sido registrado" }
  validates :email, presence: true, uniqueness: { message: "ya ha sido registrado" }
  validates :avatar, presence: true
  validates :password, presence: true, length: { minimum: 5 }
end
