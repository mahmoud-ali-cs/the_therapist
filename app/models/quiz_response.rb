# == Schema Information
#
# Table name: quiz_responses
#
#  id         :bigint           not null, primary key
#  emotion    :string
#  sound_file :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  patient_id :bigint           not null
#  quiz_id    :bigint           not null
#
# Indexes
#
#  index_quiz_responses_on_patient_id  (patient_id)
#  index_quiz_responses_on_quiz_id     (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (patient_id => patients.id)
#  fk_rails_...  (quiz_id => quizzes.id)
#
class QuizResponse < ApplicationRecord
  belongs_to :patient
  belongs_to :quiz

  mount_uploader :sound_file, SoundFileUploader

  before_validation :set_emotion

  private

  def set_emotion
    return if emotion.present?

    self.emotion = "happy"
  end
end
