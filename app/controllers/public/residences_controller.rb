class Public::ResidencesController < ApplicationController
  def index
    @residences = Residence.all
  end
end
