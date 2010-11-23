class AddMobileUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :mobile, :unique => true
  end

  def self.down
    remove_index :users, :mobile
  end
end
