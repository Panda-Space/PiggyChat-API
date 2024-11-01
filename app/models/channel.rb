class Channel < ApplicationRecord
  has_many :messages, class_name: 'Message'

  validates :website,
            presence: { message: 'es requerido(a)' }

  validates :location,
            presence: { message: 'es requerido(a)' }

  validate :unique_website_and_location

  private
    def unique_website_and_location
      if Channel.exists?(website: website, location: location)
        errors.add(:base, "El canal para esta ubicación ya ha sido creado")
      end
    end
end
