class MessageDeleteJob 
  include Sidekiq::Worker

  queue_as :default

  def perform(application_id,chat_id,message_id_in_chat)
    messages = Message.find_by(message_id_in_chat: message_id_in_chat , application_id: application_id,chat_id: chat_id)
    
    if !messages
      return
    end

    messages.destroy
  end
end
