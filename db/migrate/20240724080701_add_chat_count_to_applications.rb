class AddChatCountToApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :applications, :chats_count, :integer
  end
end
