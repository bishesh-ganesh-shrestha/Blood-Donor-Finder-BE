class Api::V1::BloodDonationRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    donation_request =
      BloodDonationRequest.new(
        blood_donation_request_params
      )

    if donation_request.save
      Notifications::CreateService.call(
        user: donation_request.donor_profile.user,
        title: "New Blood Request",
        message: "You have received a new blood donation request.",
        notifiable: donation_request
      )

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

    attributes = update_params
    status = attributes[:status]

    if status == "accepted"
      BloodDonationRequests::AcceptService
        .new(donation_request)
        .call

      render json: {
        message: "Donation request accepted",
        donation_request: donation_request.reload
      }, status: :ok

    elsif status == "declined"
      donation_request.update!(status: "declined")

      notify_blood_requester(donation_request)

      render json: {
        message: "Donation request declined",
        donation_request: donation_request.reload
      }, status: :ok

    elsif donation_request.update(attributes)
      render json: {
        message: "Request updated",
        donation_request: donation_request
      }, status: :ok
    else
      render json: {
        errors: donation_request.errors.full_messages
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Donation request not found"
    }, status: :not_found

  rescue ActiveRecord::RecordInvalid => e
    render json: {
      errors: e.record.errors.full_messages
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
      limit: 10
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
      params[:donor_latitude],
      params[:donor_longitude]
    )

    render json: {
      message: "Location updated"
    }
  end

  def show
    donation_request = BloodDonationRequest.find(params[:id])

    unless donation_request.donor_profile.user == current_user
      return render json: {
        error: "Unauthorized"
      }, status: :unauthorized
    end

    render json: {
      donation_request: donation_request,
      blood_request: donation_request.blood_request,
      donor_profile: donation_request.donor_profile
    }, status: :ok
  end

  def complete
    donation_request = BloodDonationRequest.find(params[:id])

    unless donation_request&.donor_profile&.user == current_user
      return render json: {
        error: "You are not authorized to complete this donation."
      }, status: :forbidden
    end

    BloodDonationRequests::CompleteService
      .new(donation_request)
      .call

    render json: {
      message: "Blood donation marked as completed.",
      donation_request: donation_request.reload
    }
  rescue StandardError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
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

  def notify_blood_requester(blood_donation_request)
    Notifications::CreateService.call(
      user: blood_donation_request.blood_request.user,
      title: "Blood Donor Declined Your Request",
      message: "Your blood request has been declined by #{blood_donation_request.donor_profile.user.name}.",
      notifiable: blood_donation_request.blood_request
    )
  end
end
