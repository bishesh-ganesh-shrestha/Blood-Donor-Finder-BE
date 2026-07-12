class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def push_token
    current_user.update!(
      expo_push_token: params[:expo_push_token]
    )

    render json: {
      message: "Push token updated"
    }
  end

  def me
    render json: {
      user: current_user,
      is_donor: current_user.donor_profile.present?
    }
  end
end
