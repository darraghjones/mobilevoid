class AddConfirmationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirm_code, :string
    add_column :users, :confirmed, :boolean
  end

  def self.down
    remove_column :users, :confirmed
    remove_column :users, :confirm_code
  end
end
