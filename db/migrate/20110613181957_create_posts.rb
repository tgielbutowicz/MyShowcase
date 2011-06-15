class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      #shared columns
      t.string :title
      t.text :content
      t.integer :views, :default => 0
      t.integer :likes, :default => 0
      t.integer :dislikes, :default => 0
      t.integer :user_id
      
      #polymorphic associations
      t.integer :resource_id
      t.integer :resource_type

      t.timestamps
    end
    add_index :posts, :user_id
  end

  def self.down
    drop_table :posts
  end
end
