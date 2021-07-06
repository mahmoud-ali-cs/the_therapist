class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.references :doctor, null: false, foreign_key: true
      t.string :questions, array: true, default: []

      t.timestamps
    end
  end
end
