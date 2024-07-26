
class ChatCreateJob 
  include Sidekiq::Worker

  queue_as :default

  def perform(application_id,chat_id_in_application)
    chat = Chat.create(chat_id_in_application:chat_id_in_application,application_id: application_id)
    chat.save

  end
end
