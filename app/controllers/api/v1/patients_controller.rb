class Api::V1::PatientsController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:index, :show, :update]
  # before_action :set_user, only: [:show, :update]
  authorize_resource only: [:index, :show, :update]

  # def create
  #   if current_api_v1_user.patient.present?
  #     return render_error "user already has patient role", :unprocessable_entity
  #   end

  #   patient = Patient.new create_params

  #   unless patient.save
  #     return render_model_errors patient, :unprocessable_entity
  #   end

  #   render json: {
  #     patient: ActiveModelSerializers::SerializableResource.new(
  #       @patient, serializer: PatientSerializer
  #     )
  #   }, status: :ok
  # end

  def update
    @patient = Patient.find params[:id]

    unless @patient.user.update update_user_params
      return render_model_errors @user
    end

    render json: {
      patient: ActiveModelSerializers::SerializableResource.new(
        @patient, serializer: PatientSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def show
    @patient = Patient.find params[:id]

    render json: {
      patient: ActiveModelSerializers::SerializableResource.new(
        @patient, serializer: PatientSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def index
    @patients = Patient.all

    render json: {
      patients: ActiveModelSerializers::SerializableResource.new(
        @patients, each_serializer: PatientSerializer
      )
    }, status: :ok
  end

  private

  # def create_params
  #   params.require(:user).permit(
  #     :about, :speciality
  #   )
  # rescue ActionController::ParameterMissing
  #   {}
  # end

  def update_params
    params.require(:user).permit(
      :first_name, :last_name, :birth_date, :gender
    )
  rescue ActionController::ParameterMissing
    {}
  end
end
