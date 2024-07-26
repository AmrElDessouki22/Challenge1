class ChatDeleteJob 
  include Sidekiq::Worker

  include Sidekiq::Worker
  
  queue_as :default
  
  def perform(application_id,chat_id_in_application)
    chat = Chat.find_by(application_id: application_id,chat_id_in_application: chat_id_in_application)
    if !chat
      return
    end
    chat.destroy
  end
end
