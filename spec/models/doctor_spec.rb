# == Schema Information
#
# Table name: doctors
#
#  id         :bigint           not null, primary key
#  about      :text
#  speciality :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_doctors_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Doctor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
