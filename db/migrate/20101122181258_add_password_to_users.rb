class AddPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :encrypted_password, :string
    add_column :users, :salt, :string
  end

  def self.down
    remove_column :users, :salt
    remove_column :users, :encrypted_password
  end
end
