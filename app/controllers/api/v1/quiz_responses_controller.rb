class Api::V1::QuizResponsesController < ApplicationController
  before_action :authenticate_api_v1_user!
  authorize_resource only: [:index, :show, :update]

  def create
    unless current_api_v1_user.patient.present?
      return render_error "user doesn't has patient role", :unprocessable_entity
    end

    @quiz_reponse = QuizResponse.new quiz_response_params
    @quiz_reponse.patient = current_api_v1_user.patient

    unless @quiz_reponse.save
      return render_model_errors @quiz_reponse
    end

    emotion = SerModel.process_sound_file(@quiz_reponse)
    unless emotion.present?
      return render_error "error in SER model", :unprocessable_entity
    end

    unless @quiz_reponse.update(emotion: emotion)
      return render_model_errors @quiz_reponse
    end

    render json: {
      quiz_reponse: ActiveModelSerializers::SerializableResource.new(
        @quiz_reponse, serializer: QuizResponseSerializer
      )
    }, status: :ok
  end

  def index
    @quiz_reponses = QuizResponse.all

    render json: {
      quiz_reponses: ActiveModelSerializers::SerializableResource.new(
        @quiz_reponses, each_serializer: QuizResponseSerializer
      )
    }, status: :ok
  end

  private

  def quiz_response_params
    params.require(:quiz_response).permit(
      :quiz_id, :sound_file
    )
  rescue ActionController::ParameterMissing
    {}
  end
end
