# == Schema Information
#
# Table name: quizzes
#
#  id         :bigint           not null, primary key
#  questions  :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  doctor_id  :bigint           not null
#
# Indexes
#
#  index_quizzes_on_doctor_id  (doctor_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#
class QuizSerializer < ActiveModel::Serializer
  attributes :id, :doctor_id, :questions,
    :created_at, :updated_at,
    :doctor

  def doctor
    ActiveModelSerializers::SerializableResource.new(
      object.doctor, serializer: DoctorSerializer
    )
  end
end
