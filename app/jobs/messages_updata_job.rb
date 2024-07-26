class MessagesUpdataJob
  include Sidekiq::Worker

  queue_as :default

  def perform(application_id,chat_id,message_id_in_chat,new_message_body)
    ActiveRecord::Base.transaction do
      messages = Message.lock.find_by(application_id: application_id , chat_id: chat_id , message_id_in_chat: message_id_in_chat)
      messages.update(body: new_message_body)
    end
  end
end
