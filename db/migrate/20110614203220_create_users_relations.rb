class CreateUsersRelations < ActiveRecord::Migration
  def self.up
    create_table :users_relations do |t|
      t.integer :follower_id
      t.integer :followed_id

    end
    add_index :users_relations, :follower_id
    add_index :users_relations, :followed_id
    add_index :users_relations, [:follower_id, :followed_id], :unique => true
  end

  def self.down
    drop_table :users_relations
  end
end
