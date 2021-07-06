# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      # => User
      can :read, User
      can :update, User, id: user.id

      # => Doctor
      can :read, Doctor
      can :create, Doctor
      can :update, Doctor, user_id: user.id

      # => Patient
      can :read, Patient
      can :create, Patient
      can :update, Patient, user_id: user.id

      # => Quiz
      can :read, Quiz
      can :create, Quiz
      can :update, Quiz
    end
  end
end
