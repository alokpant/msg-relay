class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :json_web_token, null: false

      t.timestamps
    end
  end
end
