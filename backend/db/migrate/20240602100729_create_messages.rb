class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
