class Avo::Resources::DonorProfile < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :blood_group, as: :text
    field :location, as: :text
    field :latitude, as: :number
    field :longitude, as: :number
    field :last_donated_at, as: :date_time
    field :available, as: :boolean
    field :verified, as: :boolean
    field :last_active_at, as: :date_time
    field :user, as: :belongs_to
    field :blood_donation_requests, as: :has_many
  end
end
