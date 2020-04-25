class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_reference :users, :organization, index: true
  	add_column :users, :admin, :boolean, default: false
  	add_column :users, :device_token, :string
  end
end
