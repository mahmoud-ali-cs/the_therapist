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
require 'rails_helper'

RSpec.describe QuizResponse, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
