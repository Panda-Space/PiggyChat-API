class Api::ChannelsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_channel, only: [:show, :edit, :update, :destroy]

  # GET /channels or /channels.json
  def index
    @channels = Channel.all
  end

  # GET /channels/1 or /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = Channel.new
  end

  # GET /channels/1/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:website, :location)
    end
end
