class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t| 
      t.string :name
      t.string :app_client_id  
      t.timestamps
    end
  end
end