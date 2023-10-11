class Admin::ResidencesController < ApplicationController
  def new
    @residence = Residence.new
  end

  def create
    @residence = Residence.new(residence_params)
    if @residence.save
      redirect_to admin_admin_path(current_admin)
    else
      render "new"
    end
  end

  def edit
    @residence = Residence.find(params[:id])
  end

  def update
    @residence = Residence.find(params[:id])
    if @residence.update(residence_params)
      redirect_to admin_admin_path(current_admin)
    else
      render "edit"
    end
  end

  def destroy
    residence = Residence.find(params[:id])
    if residence.destroy
      redirect_to admin_admin_path(current_admin)
    else
      render template: "admin/admin/show"
    end
  end

  private

  def residence_params
    params.require(:residence).permit(:admin_id, :housing_type, :name, :address)
  end
end
