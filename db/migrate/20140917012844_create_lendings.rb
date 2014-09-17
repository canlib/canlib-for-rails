class CreateLendings < ActiveRecord::Migration
  def change
    create_table :lendings do |t|
      t.integer :book_id
      t.date :date, :default => Date.today
      t.integer :period
      t.string :user_name

      t.timestamps
    end
		add_index :lendings, [:book_id]
  end
end
