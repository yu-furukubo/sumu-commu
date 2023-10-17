class Public::ReservationsController < ApplicationController
  before_action :authenticate_member!

  def index
    @reservations = Reservation.where(residence_id: current_member.residence.id)
    @reservations_mine = @reservations.where(member_id: current_member.id)
    @reservations_others = @reservations.where.not(member_id: current_member.id)
  end

  def show
    @reservation = Reservation.find(params[:id])
    if @reservation.equipment_id.present?
      @equipment_reserved = @reservation.equipment
    elsif @reservation.facility_id.present?
      @facility_reserved = @reservation.facility
    end
  end

  def select
    @equipments = Equipment.where(residence_id: current_member.residence.id)
    @facilities = Facility.where(residence_id: current_member.residence.id)
  end

  def new
    @reservation = Reservation.new
  end

  def create
    # if params[:reservation][:equipment_id].present?
    #   reservations = Reservation.where(equipment_id: params[:reservation][:equipment_id])
    # elsif params[:reservation][:facility_id].present?
    #   reservations = Reservation.where(facility_id: params[:reservation][:facility_id])
    # end
    reservation = Reservation.new(reservation_params)
    set_the_day_implement(reservation)
    pp "--------------------------", reservation, reservation.started_at, reservation.finished_at
    # if reservations.where('finished_at > ? and ? > started_at', reservation.started_at, reservation.finished_at).exists?
    #   flash.now[:notice] = "その期間にはすでに予約があります"
    #   errors.add(:started_at, :finished_at, 'その期間にはすでに予約があります')
    # end

    if reservation.save
      redirect_to public_reservation_path(reservation)
    else
      render "new"
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    reservation = Reservation.find(params[:id])
    if reservation.update(reservation_params)
      redirect_to public_reservation_path(reservation)
    else
      render "edit"
    end
  end

  def destroy
    reservation = Reservation.find(params[:id])
    if reservation.destroy
      redirect_to public_reservations_path
    else
      render "show"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:residence_id, :member_id, :equipment_id, :facility_id, :start_date, :started_at, :finish_date, :finished_at, :using_status)
  end

  def set_the_day_implement(reservation)
    start_year = reservation.start_date.year
    start_month = reservation.start_date.month
    start_day = reservation.start_date.day
    finish_year = reservation.finish_date.year
    finish_month = reservation.finish_date.month
    finish_day = reservation.finish_date.day

    reservation.started_at = reservation.started_at.change(year: start_year, month: start_month, day: start_day)
    reservation.finished_at = reservation.finished_at.change(year: finish_year, month: finish_month, day: finish_day)
  end
end
