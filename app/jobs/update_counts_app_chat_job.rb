class UpdateCountsAppChatJob
  include Sidekiq::Worker

  queue_as :scheduler

  def perform
    Application.find_each do |application|
      current_app_chat_count = application.chats.count
      application.update(chats_count: current_app_chat_count)
      application.chats.find_each do |chat|
        current_chat_message_count = chat.messages.where(application_id: application[:id]).count
        chat.update(messages_count: current_chat_message_count)
      end
    end
  end
end
