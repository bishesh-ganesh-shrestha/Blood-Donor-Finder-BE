class Api::V1::BloodRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    blood_request = current_user.blood_requests.build(
      blood_request_params
    )

    if blood_request.save
      render json: {
        message: "Blood request created successfully",
        blood_request: blood_request
      }, status: :created
    else
      render json: {
        errors: blood_request.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def index
    blood_requests = BloodRequest.order(created_at: :desc)

    render json: blood_requests
  end

  def show
    blood_request = BloodRequest.find(params[:id])

    render json: blood_request
  end

  private

  def blood_request_params
    params.require(:blood_request).permit(
      :blood_group,
      :latitude,
      :longitude,
      :urgency,
      :units_required,
      :hospital_name,
      :patient_name,
      :contact_number
    )
  end
end
