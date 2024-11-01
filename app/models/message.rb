class Message < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :channel, class_name: 'Channel'
  has_many :message_interactions, class_name: 'MessageInteraction'

  validates :content, presence: { message: 'es requerido(a)' }

  after_save :mark_as_viewed

  def parsed_created_at
    created_at.strftime("%I:%M %p")
  end

  private
    def mark_as_viewed
      MessageInteraction.create(user_id: user_id, message_id: id, viewed: true)
    end
end
