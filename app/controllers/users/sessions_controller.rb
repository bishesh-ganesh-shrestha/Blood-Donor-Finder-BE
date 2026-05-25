# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: "Logged in successfully",
      user: resource.as_json.merge(is_donor: resource.is_donor?),
      token: request.env["warden-jwt_auth.token"]
    }, status: :ok
  end

  def respond_to_on_destroy(_resource = nil)
    render json: {
      message: "Logged out successfully"
    }, status: :ok
  end
end
