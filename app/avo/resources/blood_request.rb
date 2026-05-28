class Avo::Resources::BloodRequest < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :blood_group, as: :text
    field :latitude, as: :number
    field :longitude, as: :number
    field :urgency, as: :text
    field :units_required, as: :number
    field :hospital_name, as: :text
    field :patient_name, as: :text
    field :contact_number, as: :text
    field :status, as: :text
    field :user, as: :belongs_to
    field :blood_donation_requests, as: :has_many
  end
end
