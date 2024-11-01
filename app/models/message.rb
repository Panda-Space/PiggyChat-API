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
      message_interaction = MessageInteraction.find_or_initialize_by(user_id: user_id, message_id: id) do |message_interaction|
        message_interaction.viewed = true
      end

      message_interaction.save if message_interaction.new_record?
    end
end
