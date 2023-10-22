class Public::ResidencesController < ApplicationController

  def index
    word = params[:word]
    if word.present?
      @residences = Residence.where("name LIKE :keyword OR address LIKE :keyword", keyword: "%#{word}%")
    else
      @residences = Residence.all
    end
  end
end
