class RenameAppClientIdInTableApplication < ActiveRecord::Migration[7.1]
  def change
    rename_column :applications, :app_client_id, :app_token

  end
end
