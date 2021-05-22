class Api::V1::DoctorsController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:index, :show, :update]
  # before_action :set_doctor, only: [:show, :update]
  authorize_resource only: [:index, :show, :update]

  # def create
  #   if current_api_v1_user.doctor.present?
  #     return render_error "user already has doctor role", :unprocessable_entity
  #   end

  #   doctor = Doctor.new create_params

  #   unless doctor.save
  #     return render_model_errors doctor, :unprocessable_entity
  #   end

  #   render json: {
  #     doctor: ActiveModelSerializers::SerializableResource.new(
  #       @doctor, serializer: DoctorSerializer
  #     )
  #   }, status: :ok
  # end

  def update
    @doctor = Doctor.find params[:id]

    unless @doctor.user.update update_user_params
      return render_model_errors @user
    end

    unless @doctor.update update_params
      return render_model_errors @doctor
    end

    render json: {
      doctor: ActiveModelSerializers::SerializableResource.new(
        @doctor, serializer: DoctorSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def show
    @doctor = Doctor.find params[:id]

    render json: {
      doctor: ActiveModelSerializers::SerializableResource.new(
        @doctor, serializer: DoctorSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def index
    @doctors = Doctor.all

    render json: {
      doctors: ActiveModelSerializers::SerializableResource.new(
        @doctors, each_serializer: DoctorSerializer
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
      :first_name, :last_name, :birth_date, :gender,
      :about, :speciality
    )
  rescue ActionController::ParameterMissing
    {}
  end
end
