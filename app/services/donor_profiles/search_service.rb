# frozen_string_literal: true

module DonorProfiles
  class SearchService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      donors = DonorProfile
                 .includes(:user)
                 .joins(:user)

      donors = search_by_query(donors)
      donors = filter_by_blood_group(donors)
      donors = filter_by_availability(donors)
      donors = filter_by_verification(donors)

      donors.order(created_at: :desc)
    end

    private

    def search_by_query(donors)
      return donors if params[:query].blank?

      query = "%#{params[:query]}%"

      donors.where(
        <<~SQL,
          users.name ILIKE :query
          OR users.email ILIKE :query
          OR users.phone_number ILIKE :query
          OR donor_profiles.location ILIKE :query
          OR donor_profiles.blood_group ILIKE :query
        SQL
        query: query
      )
    end

    def filter_by_blood_group(donors)
      return donors if params[:blood_group].blank?

      donors.where(blood_group: params[:blood_group])
    end

    def filter_by_availability(donors)
      return donors unless params.key?(:available)

      available = ActiveModel::Type::Boolean.new.cast(params[:available])

      available ? donors.available : donors.unavailable
    end

    def filter_by_verification(donors)
      return donors unless params.key?(:verified)

      donors.where(
        verified: ActiveModel::Type::Boolean.new.cast(params[:verified])
      )
    end
  end
end
