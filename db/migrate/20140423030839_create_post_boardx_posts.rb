class CreatePostBoardxPosts < ActiveRecord::Migration
  def change
    create_table :post_boardx_posts do |t|
      t.string :subject
      t.text :content
      t.integer :submitted_by_id
      t.integer :last_updated_by_id
      t.integer :category_id
      t.date :start_date
      t.date :expire_date

      t.timestamps
    end
    
    add_index :post_boardx_posts, :submitted_by_id
    add_index :post_boardx_posts, :subject
    add_index :post_boardx_posts, :category_id
  end
end
