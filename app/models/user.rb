# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  birth_date             :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :integer
#  last_name              :string
#  phone                  :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable
  include DeviseTokenAuth::Concerns::User

  attr_accessor :role

  # Query Interface
  # -Enums
  enum gender: {male: 0, female: 1}

  # Associations
  has_one :doctor
  has_one :patient

  # -Scopes

  # Validations
  #--password
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x.freeze

  validates :password,
            presence: true,
            length: { in: Devise.password_length },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            on: :create, if: -> { self.provider == "email" }

  validates :password,
            allow_nil: true,
            length: { in: Devise.password_length },
            format: { with: PASSWORD_FORMAT },
            confirmation: true,
            on: :update, if: -> { self.provider == "email" }

  #--first_name & last_name
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :role, presence: true, on: :create

  validate :gender_should_be_valid
  validate :role_should_be_valid, if: -> { role.present? }

  before_validation :downcase_role
  before_create :create_role_profile

  def gender=(value)
    super value
    @gender_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid gender'
    if exception.message.include? error_message
      @gender_backup = value
      self[:gender] = nil
    else
      raise
    end
  end

  private

  def gender_should_be_valid
    if @gender_backup
      self.gender ||= @gender_backup
      error_message = 'is not a valid gender'
      errors.add(:gender, error_message)
    end
  end

  def role_should_be_valid
    unless role == "doctor" || role == "patient"
      errors.add(:role, "invalid value '#{role}'")
    end
  end

  def downcase_role
    return unless role.present?
    role_value = role
    self.role = role_value.downcase
  end

  def create_role_profile
    if role == "doctor"
      self.doctor = Doctor.new
      # Doctor.create!(user: self)
    elsif role == "patient"
      self.patient = Patient.new
      # Patient.create!(user: self)
    end
  end
end
