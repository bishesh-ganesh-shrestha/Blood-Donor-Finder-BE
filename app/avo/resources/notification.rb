class Avo::Resources::Notification < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :title, as: :text
    field :message, as: :textarea
    field :read_at, as: :date_time
    field :notifiable, as: :text
  end
end
