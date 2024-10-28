class Channel < ApplicationRecord
  validates :website,
            presence: { message: 'es requerido(a)' },
            uniqueness: { message: 'ya ha sido registrado' }

  validates :location,
            presence: { message: 'es requerido(a)' },
            uniqueness: { message: 'ya ha sido registrado' }
end
