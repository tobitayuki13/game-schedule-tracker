class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :routine, null: false, foreign_key: true
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
