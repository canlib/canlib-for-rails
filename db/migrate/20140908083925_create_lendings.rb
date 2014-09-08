class CreateLendings < ActiveRecord::Migration
  def change
    create_table :lendings do |t|
      t.date :lending_date
      t.integer :lending_period
      t.string :lending_user_name

      t.timestamps
    end
  end
end
