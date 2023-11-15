class ApplicationController < ActionController::Base
  def check_adnmin_residence
    if admin_signed_in?
      unless current_admin.residences.present?
        redirect_to new_admin_residence_path
      end
    end
  end
end
