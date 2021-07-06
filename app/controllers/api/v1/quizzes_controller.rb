class Api::V1::QuizzesController < ApplicationController
  before_action :authenticate_api_v1_user!
  authorize_resource only: [:index, :show, :update]

  def create
    unless current_api_v1_user.doctor.present?
      return render_error "user doesn't has doctor role", :unprocessable_entity
    end

    @quiz = Quiz.new quiz_params
    @quiz.doctor = current_api_v1_user.doctor

    unless @quiz.save
      return render_model_errors @quiz
    end

    render json: {
      quiz: ActiveModelSerializers::SerializableResource.new(
        @quiz, serializer: QuizSerializer
      )
    }, status: :ok
  end

  def update
    unless current_api_v1_user.doctor.present?
      return render_error "user doesn't has doctor role", :unprocessable_entity
    end

    @quiz = Quiz.find params[:id]

    unless @quiz.doctor == current_api_v1_user.doctor
      return render_error "you are not allowed to do this action", :unprocessable_entity
    end

    unless @quiz.update quiz_params
      return render_model_errors @quiz
    end

    render json: {
      quiz: ActiveModelSerializers::SerializableResource.new(
        @quiz, serializer: QuizSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def show
    @quiz = Quiz.find params[:id]

    render json: {
      quiz: ActiveModelSerializers::SerializableResource.new(
        @quiz, serializer: QuizSerializer
      )
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    logger.info e
    return render_error e, :unprocessable_entity
  end

  def index
    @quizzes = Quiz.all

    render json: {
      quizzes: ActiveModelSerializers::SerializableResource.new(
        @quizzes, each_serializer: QuizSerializer
      )
    }, status: :ok
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      questions: []
    )
  rescue ActionController::ParameterMissing
    {}
  end
end
