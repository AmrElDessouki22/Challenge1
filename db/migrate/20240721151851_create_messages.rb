
class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :chat, null: false, foreign_key: true
      t.references :application, null: false, foreign_key: true
      t.datetime :timestamp
      t.integer :message_id_in_chat

      t.timestamps
    end
  end
end
