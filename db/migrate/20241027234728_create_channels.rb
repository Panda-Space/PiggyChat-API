class CreateChannels < ActiveRecord::Migration[7.2]
  def change
    create_table :channels do |t|
      t.string :website, null: false
      t.string :location, null: false

      t.timestamps
    end
  end
end
