# app/controllers/avo/tools_controller.rb
class Avo::ToolsController < Avo::ApplicationController
  def dashboard
    @page_title = "Dashboard"
    add_breadcrumb "Dashboard"

    # --- Stat cards ---
    @total_users          = User.count
    @total_donors         = DonorProfile.count
    @available_donors     = DonorProfile.where(available: true).count
    @verified_donors      = DonorProfile.where(verified: true).count
    @total_requests       = BloodRequest.count
    @pending_requests     = BloodRequest.where(status: "pending").count
    @fulfilled_requests   = BloodRequest.where(status: "fulfilled").count
    @total_responses      = BloodDonationRequest.count

    # --- Charts ---
    @requests_over_time       = BloodRequest.group_by_month(:created_at, last: 6).count
    @requests_by_blood_group  = BloodRequest.group(:blood_group).count
    @requests_by_urgency      = BloodRequest.group(:urgency).count
    @donors_by_blood_group    = DonorProfile.group(:blood_group).count
    @responses_by_status      = BloodDonationRequest.group(:status).count
    @new_donors_over_time     = DonorProfile.group_by_month(:created_at, last: 6).count
  end
end
