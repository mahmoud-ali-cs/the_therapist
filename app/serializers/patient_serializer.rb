# == Schema Information
#
# Table name: patients
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_patients_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class PatientSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phone, :gender, :birth_date,
    :created_at, :updated_at

  def first_name
    object.user.first_name
  end

  def last_name
    object.user.last_name
  end

  def email
    object.user.email
  end

  def phone
    object.user.phone
  end

  def gender
    object.user.gender
  end

  def birth_date
    object.user.birth_date
  end
end
