class AddAuthorIdToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :author_id, :bigint
    add_index :posts, :author_id
    add_foreign_key :posts, :users, column: :author_id
  end
end
