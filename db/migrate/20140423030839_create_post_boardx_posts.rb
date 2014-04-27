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
      t.integer :post_zone_id
      t.integer :post_role_id
      t.integer :post_group_id  #group here is the sys_user_group in authentify
      t.integer :post_task_id

      t.timestamps
    end
    
    add_index :post_boardx_posts, :submitted_by_id
    add_index :post_boardx_posts, :subject
    add_index :post_boardx_posts, :category_id
    add_index :post_boardx_posts, :post_zone_id
  end
end
