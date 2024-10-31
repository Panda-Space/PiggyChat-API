class CreateMessageInteractions < ActiveRecord::Migration[7.2]
  def change
    create_table :message_interactions do |t|
      t.references :message, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.boolean :viewed
      t.boolean :liked

      t.timestamps
    end

    add_index :message_interactions, [:message_id, :user_id], unique: true
  end
end
