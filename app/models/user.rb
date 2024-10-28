class User < ApplicationRecord
  require 'securerandom'
  has_secure_password

  enum avatar: { red: 'red', green: 'green', blue: 'blue' } #TODO: Terminar el path correcto para esto

  validates :username,
            presence: { message: 'es requerido(a)' },
            uniqueness: { message: "ya ha sido registrado" }

  validates :email,
            presence: { message: 'es requerido(a)' },
            uniqueness: { message: "ya ha sido registrado" }

  validates :avatar,
            presence: { message: 'es requerido(a)' }

  validates :password,
            presence: { message: 'es requerido(a)' },
            length: { minimum: 5 }
end
