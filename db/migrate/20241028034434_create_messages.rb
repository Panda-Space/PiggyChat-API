class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :channel, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false, index: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :messages, :channel_id
    add_index :messages, :user_id
  end
end
