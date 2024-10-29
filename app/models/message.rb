class Message < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :channel, class_name: 'Channel'

  validates :content, presence: { message: 'es requerido(a)' }
end
