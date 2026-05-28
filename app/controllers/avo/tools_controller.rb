# app/controllers/avo/tools_controller.rb

class Avo::ToolsController < Avo::ApplicationController
  def dashboard
    @page_title = "Dashboard"
    add_breadcrumb "Dashboard"

    # --- Filters from params ---
    @date_range  = params[:date_range]  || "this_month"
    @blood_group = params[:blood_group]
    @urgency     = params[:urgency]
    @status      = params[:status]
    @search      = params[:search]

    start_date = case @date_range
    when "today"         then Time.current.beginning_of_day
    when "this_week"     then Time.current.beginning_of_week
    when "this_month"    then Time.current.beginning_of_month
    when "last_3_months" then 3.months.ago
    when "last_6_months" then 6.months.ago
    when "this_year"     then Time.current.beginning_of_year
    end

    # --- Base scopes ---
    requests_scope  = BloodRequest.all
    requests_scope  = requests_scope.where(created_at: start_date..) if start_date
    requests_scope  = requests_scope.where(blood_group: @blood_group) if @blood_group.present?
    requests_scope  = requests_scope.where(urgency: @urgency)         if @urgency.present?
    requests_scope  = requests_scope.where(status: @status)           if @status.present?

    donors_scope = DonorProfile.all
    donors_scope = donors_scope.where(created_at: start_date..) if start_date
    donors_scope = donors_scope.where(blood_group: @blood_group) if @blood_group.present?

    responses_scope = BloodDonationRequest.all
    responses_scope = responses_scope.where(created_at: start_date..) if start_date

    # --- Stat cards ---
    @total_users        = User.count
    @total_donors       = DonorProfile.count
    @available_donors   = DonorProfile.where(available: true).count
    @verified_donors    = DonorProfile.where(verified: true).count
    @total_requests     = requests_scope.count
    @pending_requests   = requests_scope.where(status: "pending").count
    @fulfilled_requests = requests_scope.where(status: "fulfilled").count
    @total_responses    = responses_scope.count
    @fulfillment_rate   = @total_requests > 0 ? (@fulfilled_requests.to_f / @total_requests * 100).round(1) : 0
    @response_rate      = @total_requests > 0 ? (@total_responses.to_f / @total_requests * 100).round(1) : 0

    # --- Chart grouping based on date range ---
    last_n = case @date_range
    when "today", "this_week" then 7
    when "this_month"         then 30
    when "last_3_months"      then 3
    when "this_year"          then 12
    else 6
    end
    period_method = @date_range.in?(%w[today this_week]) ? :group_by_day : :group_by_month

    @requests_over_time      = requests_scope.send(period_method, :created_at, last: last_n).count
    @new_donors_over_time    = donors_scope.send(period_method, :created_at, last: last_n).count
    @requests_by_blood_group = requests_scope.group(:blood_group).count
    @donors_by_blood_group   = donors_scope.group(:blood_group).count
    @requests_by_urgency     = requests_scope.group(:urgency).count
    @responses_by_status     = responses_scope.group(:status).count
    @requests_vs_responses   = [
      { name: "Requests",  data: requests_scope.send(period_method, :created_at, last: last_n).count },
      { name: "Responses", data: responses_scope.send(period_method, :created_at, last: last_n).count }
    ]

    # --- Recent requests (with search) ---
    recent_scope = requests_scope.includes(:user).order(created_at: :desc)
    if @search.present?
      recent_scope = recent_scope.where(
        "patient_name ILIKE :q OR hospital_name ILIKE :q OR blood_group ILIKE :q OR contact_number ILIKE :q",
        q: "%#{@search}%"
      )
    end
    @recent_requests = recent_scope.limit(10)

    # --- Top donors by response count ---
    @top_donors = DonorProfile.joins(:blood_donation_requests)
                              .joins(:user)
                              .select("donor_profiles.*, users.name AS user_name, users.email AS user_email, COUNT(blood_donation_requests.id) AS response_count")
                              .group("donor_profiles.id, users.name, users.email")
                              .order("response_count DESC")
                              .limit(8)

    # --- Filter option lists ---
    @blood_groups = BloodRequest.distinct.pluck(:blood_group).compact.sort
    @urgencies    = BloodRequest.distinct.pluck(:urgency).compact.sort
    @statuses     = BloodRequest.distinct.pluck(:status).compact.sort
  end

  def export_requests
    requests = BloodRequest.includes(:user).order(created_at: :desc)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[ID Patient Hospital BloodGroup Units Urgency Status ContactNumber CreatedAt]
      requests.each do |r|
        csv << [ r.id, r.patient_name, r.hospital_name, r.blood_group,
                r.units_required, r.urgency, r.status, r.contact_number, r.created_at.strftime("%Y-%m-%d") ]
      end
    end

    send_data csv_data, filename: "blood_requests_#{Date.today}.csv", type: "text/csv"
  end
end
