class Public::ReservationsController < ApplicationController
  before_action :authenticate_member!

  def index
    @reservations = Reservation.where(residence_id: current_member.residence.id)
    @reservations_mine = @reservations.where(member_id: current_member.id)
    @reservations_others = @reservations.where.not(member_id: current_member.id)
    @equipments = Equipment.where(residence_id: current_member.residence.id)
    @facilities = Facility.where(residence_id: current_member.residence.id)
  end

  def show
    @reservation = Reservation.find(prams[:id])
    if @reservation.equipment_id.prenset?
      @equipment_reserved = @reservation.equipment
    elsif @reservation.facility_id.prenset?
      @facility_reserved = @reservation.facility
    end
  end

  def new
    @reservation = Reservation.new
  end

  def create
    reservation = Reservation.new(reservation_params)
    if reservation.save
      redirect_to public_reservation_path(reservation)
    else
      render "new"
    end
  end

  def edit
    @reservation = Reservation.find(prams[:id])
  end

  def update
    reservation = Reservation.find(prams[:id])
    if reservation.update(reservation_params)
      redirect_to public_reservation_path(reservation)
    else
      render "edit"
    end
  end

  def destroy
    reservation = Reservation.find(prams[:id])
    if reservation.destroy
      redirect_to public_reservations_path
    else
      render "show"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:residence_id, :member_id, :equipment_id, :facility_id, :start_date, :started_at, :finish_date, :finished_at, :useing_status)
  end
end
