class Api::ChannelsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_channel, only: [:show, :create_messages, :update_messages]
  before_action :check_filter, only: [:index]

  def index
    website = params[:website]
    location = params[:location]

    channels = Channel.find_by(website: website, location: location)

    render json: { data: channels }, status: :ok
  end

  def show
    if @channel
      render json: { data: @channel }, status: :ok
    else
      render json: { message: 'No se encontró el canal' }, status: :not_found
    end
  end

  def create
    begin
      channel = Channel.new(channel_params)
      channel.save!

      render json: { data: channel }, status: :ok
    rescue StandardError => e
      response = { error: e.message, message: 'No se pudo crear el canal (error desconocido)' }
      response[:message] = channel.errors.full_messages.join(', ') unless channel.nil?

      render json: response, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /channels/1 or /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, notice: "Channel was successfully updated." }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1 or /channels/1.json
  def destroy
    @channel.destroy!

    respond_to do |format|
      format.html { redirect_to channels_path, status: :see_other, notice: "Channel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def messages
    channel_id = params[:id]
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    unread = params[:unread] || false
    user_id = @current_user.id

    if unread
      unread_messages_count = 0
      message_base_query = Message.select(:id).where(channel_id: channel_id)
      last_message_interaction = MessageInteraction.joins(:channel)
                                                   .where(user_id: user_id)
                                                   .where(viewed: true)
                                                   .where(channel: { id: channel_id })
                                                   .last

      if last_message_interaction
        unread_messages_count = message_base_query.where('created_at > ?', last_message_interaction.created_at).limit(11).size
      else
        unread_messages_count = message_base_query.limit(11).size
      end

      data = { count: unread_messages_count }
    else
      data = Message.where(channel_id: channel_id).page(page).per(per_page)
    end

    render json: { data: data }, status: :ok
  end

  def create_messages
    begin
      render json: { message: 'No se encontró el canal' }, status: :not_found and return if @channel.nil?

      user_id = @current_user.id
      message = @channel.messages.create(**message_params, user_id: user_id)

      if message.id
        broadcast(message: message) # TODO: Llevarlo a un Job para trabajo paralelo
        render json: { data: message }, status: :ok
      else
        render json: { message: 'No se pudo enviar tu mensaje' }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message, message: 'No se pudo enviar tu mensaje (error desconocido)' }, status: :unprocessable_entity
    end
  end

  def update_messages
    render json: { message: 'No se encontró el canal' }, status: :not_found and return if @channel.nil?

    operation = params[:operation]
    user_id = @current_user.id

    case operation
    when 'mark_as_viewed'
      message_ids = params[:message_ids]
      message_interactions = message_ids.map { |message_id| { user_id: user_id, message_id: message_id, viewed: true } }

      message_interactions.in_groups_of(500, false) do |batch|
        MessageInteraction.import batch, on_duplicate_key_ignore: true
      end

      render json: { data: message_interactions }, status: :ok
    end
  end

  private
    def set_channel
      begin
        @channel = Channel.find(params[:id])
      rescue
        nil
      end
    end

    def channel_params
      params.require(:channel).permit(:website, :location)
    end

    def message_params
      params.require(:message).permit(:content)
    end

    def check_filter
      params_message = []
      params_message << 'website esta vacio' if params[:website].nil?
      params_message << 'location esta vacio' if params[:location].nil?

      render json: { message: params_message.join(', ').capitalize }, status: :unprocessable_entity and return if params_message.any?
    end

    def broadcast(message:)
      channel_id = @channel.id
      user = message.user

      ActionCable.server.broadcast(
        "chat_#{channel_id}",
        {
          user: {
            id: user.id,
            username: user.username,
            avatar: user.avatar
          },
          body: {
            id: message.id,
            channel_id: message.channel_id,
            created_at: message.parsed_created_at,
            content: message.content
          }
        }
      )
    end
end
