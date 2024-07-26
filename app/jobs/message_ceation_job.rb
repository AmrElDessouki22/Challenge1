class MessageCeationJob
  include Sidekiq::Worker

  queue_as :default

  def perform(application_id,chat_id,message_id_in_chat,body)
    message = Message.create(message_id_in_chat: message_id_in_chat,application_id: application_id ,chat_id: chat_id, body: body)
    message.save
  end
end
