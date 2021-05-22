class CreateDoctors < ActiveRecord::Migration[6.0]
  def change
    create_table :doctors do |t|
      t.text :about
      t.string :speciality
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
