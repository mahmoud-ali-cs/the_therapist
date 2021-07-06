class CreateQuizResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_responses do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.string :sound_file, null: false
      t.string :emotion

      t.timestamps
    end
  end
end
