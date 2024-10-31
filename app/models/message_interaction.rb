class MessageInteraction < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :message, class_name: 'Message'
  has_one :channel, through: :message, class_name: 'Channel'
end
