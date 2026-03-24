class AddAuthorIdToComments < ActiveRecord::Migration[8.1]
  def change
    remove_column :comments, :author, :string
    add_column :comments, :author_id, :bigint
    add_index :comments, :author_id
    add_foreign_key :comments, :users, column: :author_id
  end
end
