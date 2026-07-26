class Api::V1::DonorProfilesController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.donor_profile.present?
      return render json: {
        error: "Donor profile already exists"
      }, status: :unprocessable_entity
    end

    donor_profile = current_user.build_donor_profile(donor_profile_params)

    if donor_profile.save
      render json: {
        message: "Donor profile created successfully",
        donor_profile: donor_profile_json(donor_profile)
      }, status: :created
    else
      render json: {
        errors: donor_profile.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def index
    pagy, donors = pagy(
      DonorProfiles::SearchService.new(params).call,
      items: 10
    )

    render json: {
      donors: donors.as_json(
        only: [
          :id,
          :blood_group,
          :latitude,
          :longitude,
          :last_donated_at,
          :verified
        ],
        methods: [ :available ],
        include: {
          user: {
            only: [
              :id,
              :name,
              :email,
              :phone_number
            ]
          }
        }
      ),
      meta: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count
      }
    }
  end

  def show
    donor_profile = current_user.donor_profile

    if donor_profile
      render json: donor_profile_json(donor_profile)
    else
      render json: {
        error: "Donor profile not found"
      }, status: :not_found
    end
  end

  def update
    donor_profile = current_user.donor_profile

    return render_not_found unless donor_profile

    if donor_profile.update(donor_profile_params)
      render json: {
        message: "Donor profile updated successfully",
        donor_profile: donor_profile_json(donor_profile)
      }
    else
      render json: {
        errors: donor_profile.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def donor_profile_params
    params.require(:donor_profile).permit(
      :blood_group,
      :latitude,
      :longitude,
      :last_donated_at,
    )
  end

  def render_not_found
    render json: {
      error: "Donor profile not found"
    }, status: :not_found
  end

  def donor_profile_json(donor_profile)
    donor_profile.as_json(
      methods: [ :available ],
      include: {
        user: {
          only: [ :id, :name, :email, :phone_number ]
        }
      }
    )
  end
end
