class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :ar
      t.string :a
      t.string :s
      t.string :pattern
      t.string :what

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
