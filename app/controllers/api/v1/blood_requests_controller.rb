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
    pagy, blood_requests = pagy(
      BloodRequest.where.not(status: "fulfilled").order(created_at: :desc),
      limit: 10
    )

    render json: {
      blood_requests: blood_requests,
      meta: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count
      }
    }
  end

  def show
    blood_request = BloodRequest.find(params[:id])

    render json: blood_request
  end

  def my_requests
    pagy, blood_requests = pagy(
      current_user.blood_requests.order(created_at: :desc),
      limit: 10
    )

    render json: {
      blood_requests: blood_requests,
      meta: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count
      }
    }
  end

  def matching_donors
    blood_request = BloodRequest.find(params[:id])

    donors = DonorMatchingService
              .new(blood_request)
              .call

    render json: {
      blood_request: blood_request,
      donors: donors
    }
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
