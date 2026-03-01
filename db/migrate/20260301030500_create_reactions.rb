class CreateReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions do |t|
      t.string :kind, null: false
      t.bigint :user_id, null: true
      t.references :reactionable, polymorphic: true, null: false, index: true

      t.timestamps
    end

    add_index :reactions, [:reactionable_type, :reactionable_id, :user_id, :kind], name: 'index_reactions_on_reactable_user_kind'
  end
end
