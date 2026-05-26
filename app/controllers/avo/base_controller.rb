class Avo::BaseController < Avo::ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    unless current_user&.is_admin?
      redirect_to main_app.root_path,
                  alert: "You are not authorized."
    end
  end
end
