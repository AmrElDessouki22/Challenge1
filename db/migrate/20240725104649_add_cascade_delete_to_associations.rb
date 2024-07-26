class AddCascadeDeleteToAssociations < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :chats, :applications
    remove_foreign_key :messages, :applications
    remove_foreign_key :messages, :chats

    add_foreign_key :chats, :applications, on_delete: :cascade
    add_foreign_key :messages, :applications, on_delete: :cascade
    add_foreign_key :messages, :chats, on_delete: :cascade
  end
end
