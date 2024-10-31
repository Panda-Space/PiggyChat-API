class Message < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :channel, class_name: 'Channel'
  has_many :message_interactions, class_name: 'MessageInteraction'

  validates :content, presence: { message: 'es requerido(a)' }
end
