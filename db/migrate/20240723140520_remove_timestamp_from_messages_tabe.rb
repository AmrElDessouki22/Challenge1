class RemoveTimestampFromMessagesTabe < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :timestamp, :datetime

  end
end
