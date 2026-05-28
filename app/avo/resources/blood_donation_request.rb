class Avo::Resources::BloodDonationRequest < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :blood_request_id, as: :number
    field :donor_profile_id, as: :number
    field :status, as: :text
    field :message, as: :textarea
    field :responded_at, as: :date_time
    field :tracking_enabled, as: :boolean
    field :donor_latitude, as: :number
    field :donor_longitude, as: :number
    field :blood_request, as: :belongs_to
    field :donor_profile, as: :belongs_to
  end
end
