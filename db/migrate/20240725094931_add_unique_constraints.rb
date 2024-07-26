class AddUniqueConstraints < ActiveRecord::Migration[7.1]
  def change
    add_index :chats, [:chat_id_in_application, :application_id], unique: true
    add_index :messages, [:message_id_in_chat, :chat_id, :application_id], unique: true
  end
end
