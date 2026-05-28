class Api::V1::BloodDonationRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    donation_request =
      BloodDonationRequest.new(
        blood_donation_request_params
      )

    if donation_request.save
      render json: {
        message: "Blood donation request sent",
        donation_request: donation_request
      }, status: :created
    else
      render json: {
        errors: donation_request.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    donation_request =
      current_user
        .donor_profile
        .blood_donation_requests
        .find(params[:id])

    if update_params[:status] == "accepted"
      BloodDonationRequests::AcceptService
        .new(donation_request)
        .call

      render json: {
        message: "Donation request accepted",
        donation_request: donation_request.reload
      }, status: :ok
    elsif donation_request.update(update_params)
      render json: {
        message: "Request updated",
        donation_request: donation_request
      }, status: :ok
    else
      render json: {
        errors: donation_request.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def index
    requests =
      current_user
        .donor_profile
        &.blood_donation_requests
        &.includes(:blood_request)

    pagy, requests = pagy(
      requests.order(created_at: :desc),
      items: 10
    )

    render json: {
      requests: requests.as_json(
        include: :blood_request
      ),
      meta: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count
      }
    }
  end

  def update_location
    donation_request =
      BloodDonationRequest.find(params[:id])

    unless donation_request.donor_profile.user == current_user
      return render json: {
        error: "Unauthorized"
      }, status: :unauthorized
    end

    DonorTrackingService.broadcast_location(
      donation_request,
      params[:latitude],
      params[:longitude]
    )

    render json: {
      message: "Location updated"
    }
  end

  private

  def blood_donation_request_params
    params.require(:blood_donation_request).permit(
      :blood_request_id,
      :donor_profile_id,
      :message
    )
  end

  def update_params
    params.require(:blood_donation_request).permit(
      :status
    )
  end
end
