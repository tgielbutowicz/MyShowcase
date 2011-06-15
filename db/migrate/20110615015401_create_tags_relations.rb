class CreateTagsRelations < ActiveRecord::Migration
  def self.up
    create_table :tags_relations do |t|
      t.integer :post_id
      t.integer :tag_id
    end
    add_index :tags_relations, :post_id
    add_index :tags_relations, :tag_id
  end

  def self.down
    drop_table :tags_relations
  end
end
