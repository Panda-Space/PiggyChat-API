class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"

    transmit({ message: "Bienvenido al canal de chat" })
  end

  def receive(data)
    puts data.inspect
  end
end